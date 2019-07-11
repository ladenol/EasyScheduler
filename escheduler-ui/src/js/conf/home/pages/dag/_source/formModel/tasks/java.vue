<template>
  <div class="java-model">
    <m-list-box>
      <div slot="text">{{$t('Main jar package')}}</div>
      <div slot="content">
        <x-select
                style="width: 100%;"
                :placeholder="$t('Please enter main jar package')"
                v-model="mainJar"
                filterable
                :disabled="isDetails">
          <x-option
                  v-for="city in mainJarList"
                  :key="city.code"
                  :value="city.code"
                  :label="city.code">
          </x-option>
        </x-select>
      </div>
    </m-list-box>
    <m-list-box>
      <div slot="text">{{$t('JVM Parameters')}}</div>
      <div slot="content">
        <x-input
                :autosize="{minRows:2}"
                :disabled="isDetails"
                type="textarea"
                v-model="jvmArgs"
                :placeholder="$t('Please enter JVM parameters')"
                autocomplete="off">
        </x-input>
      </div>
    </m-list-box>
    <m-list-box>
      <div slot="text">{{$t('Command-line parameters')}}</div>
      <div slot="content">
        <x-input
                :autosize="{minRows:2}"
                :disabled="isDetails"
                type="textarea"
                v-model="mainArgs"
                :placeholder="$t('Please enter Command-line parameters')"
                autocomplete="off">
        </x-input>
      </div>
    </m-list-box>
    <m-list-box>
      <div slot="text">{{$t('Resources')}}</div>
      <div slot="content">
        <m-resources
                ref="refResources"
                @on-resourcesData="_onResourcesData"
                :resource-list="resourceList">
        </m-resources>
      </div>
    </m-list-box>
  </div>
</template>
<script>
  import _ from 'lodash'
  import i18n from '@/module/i18n'
  import mListBox from './_source/listBox'
  import mResources from './_source/resources'
  import disabledState from '@/module/mixin/disabledState'

  export default {
    name: 'java',
    data () {
      return {
        // Master jar package
        mainJar: null,
        // Master jar package(List)
        mainJarList: [],
        // Resource(list)
        resourceList: [],
        // Command line argument
        mainArgs: '',
        // JVM parameters
        jvmArgs : '',
      }
    },
    props: {
      backfillItem: Object
    },
    mixins: [disabledState],
    methods: {
      /**
       * return resourceList
       */
      _onResourcesData (a) {
        this.resourceList = a
      },
      /**
       * verification
       */
      _verification () {
        if (!this.mainJar) {
          this.$message.warning(`${i18n.$t('Please enter main jar package')}`)
          return false
        }

        if (!this.$refs.refResources._verifResources()) {
          return false
        }

        // storage
        this.$emit('on-params', {
          mainJar: {
            res: this.mainJar
          },
          resourceList: this.resourceList,
          mainArgs: this.mainArgs,
          jvmArgs: this.jvmArgs,
        })
        return true
      },
      /**
       * get resources list
       */
      _getResourcesList () {
        return new Promise((resolve, reject) => {
          let isJar = (alias) => {
            return alias.substring(alias.lastIndexOf('.') + 1, alias.length) !== 'jar'
          }
          this.mainJarList = _.map(_.cloneDeep(this.store.state.dag.resourcesListS), v => {
            return {
              id: v.id,
              code: v.alias,
              disabled: isJar(v.alias)
            }
          })
          resolve()
        })
      }
    },
    watch: {},
    created () {
      this._getResourcesList().then(() => {
        let o = this.backfillItem

        // Non-null objects represent backfill
        if (!_.isEmpty(o)) {
          this.mainJar = o.params.mainJar.res || ''
          this.mainArgs = o.params.mainArgs || ''
          this.jvmArgs = o.params.jvmArgs || ''

          // backfill resourceList
          let resourceList = o.params.resourceList || []
          if (resourceList.length) {
            this.resourceList = resourceList
          }
        }
      })
    },
    mounted () {

    },
    components: { mListBox, mResources }
  }
</script>

<style lang="scss" rel="stylesheet/scss">
  .java-model {
    .list-box-4p {
      .list {
        margin-bottom: 14px;
        .sp1 {
          float: left;
          width: 112px;
          text-align: right;
          margin-right: 10px;
          font-size: 14px;
          color: #777;
          display: inline-block;
          padding-top: 6px;
        }
        .sp2 {
          float: left;
          margin-right: 4px;
        }
        .sp3 {
          width: 176px;
        }
      }
    }
  }
</style>
