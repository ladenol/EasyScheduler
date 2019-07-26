<template>
  <div class="list-model">
    <div class="table-box">
      <table class="fixed">
        <tr>
          <th>
            <span>{{$t('#')}}</span>
          </th>
          <th>
            <span>{{$t('Name')}}</span>
          </th>
          <th>
            <span>{{$t('Process Instance')}}</span>
          </th>
          <th width="80">
            <span>{{$t('Node Type')}}</span>
          </th>
          <th width="40">
            <span>{{$t('State')}}</span>
          </th>
          <th width="140">
            <span>{{$t('Submit Time')}}</span>
          </th>
          <th width="140">
            <span>{{$t('Start Time')}}</span>
          </th>
          <th width="140">
            <span>{{$t('End Time')}}</span>
          </th>
          <th width="110">
            <span>{{$t('host')}}</span>
          </th>
          <th width="74">
            <span>{{$t('Duration')}}(s)</span>
          </th>
          <th width="84">
            <span>{{$t('Retry Count')}}</span>
          </th>
          <th width="102">
            <span>{{$t('Operation')}}</span>
          </th>
        </tr>
        <tr v-for="(item, $index) in list" :key="item.id">
          <td>
            <span>{{parseInt(pageNo === 1 ? ($index + 1) : (($index + 1) + (pageSize * (pageNo - 1))))}}</span>
          </td>
          <td>
            <span class="ellipsis"><a href="javascript:" class="links">{{item.name}}</a></span>
          </td>
          <td><a href="javascript:" class="links" @click="_go(item)"><span class="ellipsis">{{item.processInstanceName}}</span></a></td>
          <td><span>{{item.taskType}}</span></td>
          <td><span v-html="_rtState(item.state)" style="cursor: pointer;"></span></td>
          <td><span>{{item.submitTime | formatDate}}</span></td>
          <td><span>{{item.startTime | formatDate}}</span></td>
          <td>
            <span v-if="item.endTime">{{item.endTime | formatDate}}</span>
            <span v-if="!item.endTime">-</span>
          </td>
          <td><span>{{item.host || '-'}}</span></td>
          <td><span>{{item.duration}}</span></td>
          <td><span>{{item.retryTimes}}</span></td>
          <td>
            <x-button
                    type="info"
                    shape="circle"
                    size="xsmall"
                    data-toggle="tooltip"
                    :title="$t('View log')"
                    icon="iconfont icon-xitongcaozuorizhi"
                    @click="_refreshLog(item)">
            </x-button>
            <x-button
                    type="info"
                    shape="circle"
                    size="xsmall"
                    data-toggle="tooltip"
                    :title="$t('Download')"
                    :disabled="_rtDisb(item)"
                    @click="_downloadFile(item)"
                    icon="iconfont icon-download"
                    v-ps="['GENERAL_USER']">
            </x-button>
	    <x-poptip
                    :ref="'poptip-' + $index"
                    placement="bottom-end"
                    width="90">
              <p>{{$t('Delete?')}}</p>
              <div style="text-align: right; margin: 0;padding-top: 4px;">
                <x-button type="text" size="xsmall" shape="circle" @click="_closeDelete($index)">{{$t('Cancel')}}</x-button>
                <x-button type="primary" size="xsmall" shape="circle" @click="_delete(item,$index)">{{$t('Confirm')}}</x-button>
              </div>
              <template slot="reference">
                <x-button
                        icon="iconfont icon-shanchu"
                        type="error"
                        shape="circle"
                        size="xsmall"
                        data-toggle="tooltip"
                        :title="$t('delete')"
                        :disabled="_rtDisb(item)"
                        v-ps="['GENERAL_USER']">
                </x-button>
              </template>
            </x-poptip>
          </td>
        </tr>
      </table>
    </div>
  </div>
</template>
<script>
  import Permissions from '@/module/permissions'
  import { mapActions } from 'vuex'
  import mLog from '@/conf/home/pages/dag/_source/formModel/log'
  import localStore from '@/module/util/localStorage'
  import { tasksState } from '@/conf/home/pages/dag/_source/config'
  import { downloadFile } from '@/module/download'

  export default {
    name: 'list',
    data () {
      return {
        list: [],
        isAuth: Permissions.getAuth(),
        backfillItem: {}
      }
    },
    props: {
      taskInstanceList: Array,
      pageNo: Number,
      pageSize: Number
    },
    methods: {
      ...mapActions('resource', ['deleteResource']),
      _rtDisb (item) {
	return item.resourceId == -1
      },
      _downloadFile (item) {
        downloadFile('/escheduler/resources/download', {
          id: item.resourceId
        })
      },
      _closeDelete (i) {
        this.$refs[`poptip-${i}`][0].doClose()
      },
      _delete (item, i) {
        this.deleteResource({
          id: item.resourceId
        }).then(res => {
          this.$refs[`poptip-${i}`][0].doClose()
          this.$message.success(res.msg)
          this._onUpdate()
        }).catch(e => {
          this.$refs[`poptip-${i}`][0].doClose()
          this.$message.error(e.msg || '')
        })
      },
      _rtState (code) {
        let o = tasksState[code]
        return `<em class="iconfont ${o.isSpin ? 'fa fa-spin' : ''}" style="color:${o.color}" data-toggle="tooltip" data-container="body" title="${o.desc}">${o.icoUnicode}</em>`
      },
      _onUpdate () {
        this.$emit('on-update')
      },
      _refreshLog (item) {
        let self = this
        let instance = this.$modal.dialog({
          closable: false,
          showMask: true,
          escClose: true,
          className: 'v-modal-custom',
          transitionName: 'opacityp',
          render (h) {
            return h(mLog, {
              on: {
                ok () {
                },
                close () {
                  instance.remove()
                }
              },
              props: {
                self: self,
                source: 'list',
                logId: item.id
              }
            })
          }
        })
      },
      _go (item) {
        this.$router.push({ path: `/projects/instance/list/${item.processInstanceId}` })
      },
    },
    watch: {
      taskInstanceList (a) {
        this.list = []
        setTimeout(() => {
          this.list = a
        })
      }
    },
    created () {
    },
    mounted () {
      this.list = this.taskInstanceList
    },
    components: { }
  }
</script>
