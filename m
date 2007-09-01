Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbXIAE6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbXIAE6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 00:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbXIAE6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 00:58:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751927AbXIAE61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 00:58:27 -0400
Date: Fri, 31 Aug 2007 21:58:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc4-mm1
Message-Id: <20070831215822.26e1432b.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/

- git-kbuild is broken and has been dropped

- git-ixgb is broken by git-net and has been dropped

- git-md-accel is broken by MD fixes and has been dropped

- git-v9fs breaks the build on all non-x86 and the fs has been disabled in
  config

- dynticks-for-x86_64 has returned



Changes since 2.6.23-rc3-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-audit-master.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-jg-misc.patch
 git-kvm.patch
 git-libata-all.patch
 git-m32r.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-netdev-all.patch
 git-net.patch
 git-backlight.patch
 git-nfs.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-r8169.patch
 git-selinux.patch
 git-s390.patch
 git-sched.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-block.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-xtensa.patch
 git-kgdb.patch

 git trees

-ecryptfs-fix-lookup-error-for-special-files.patch
-sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
-tpmdd-maintainers.patch
-kernel-auditscc-fix-an-off-by-one.patch
-document-linux-memory-policy-v3.patch
-futex_unlock_pi-hurts-my-brain-and-may-cause.patch
-dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
-serial-add-support-for-ite-887x-chips.patch
-serial_txx9-fix-modem-control-line-handling.patch
-serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
-add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
-free_irq-fix-debug_shirq-handling.patch
-documentation-fix-getdelaysc-example-l-option-and-segv.patch
-h8300-missing-include.patch
-ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
-wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
-wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch
-correct-name-for-rtc-m41t80.patch
-fix-null-pointer-dereference-in-__vm_enough_memory.patch
-m68k-asm-pageh-needs-linux-compilerh.patch
-m68k-kill-superfluous-extern.patch
-m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch
-remove-dead-code-in-via-pmu68k.patch
-m68k-use-_ac-instead-of-ifdef-__assembly__.patch
-m68k-enable-arbitary-speed-tty-support.patch
-m68k-dont-include-rodata-into-text-segment.patch
-m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch
-zorro-make-sysfs-config-attribute-read-only.patch
-m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible.patch
-introduce-config_check_signature-was-re-uninline.patch
-posix-timers-fix-deletion-race.patch
-posix-timers-fix-creation-race.patch
-signalfd-fix-interaction-with-posix-timers.patch
-signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch
-ipmi-fix-warning-in-ipmi_si_intfc.patch
-slab-skip-calling-cache_free_alien-when-the-platform-is-not-numa-capable.patch
-synclink_gt-fix-module-reference.patch
-fix-vm_fault-flags-conversion-for-hugetlb.patch
-w1-fix-w1_remove_master_device-searching.patch
-md-make-sure-a-re-add-after-a-restart-honours-bitmap-when-resyncing.patch
-md-correctly-update-sysfs-when-a-raid1-is-reshaped.patch
-uml-fix-previous-request-size-limit-fix.patch
-autofs4-deadlock-during-create.patch
-serial-add-pci-ids-for-pa-semi-pwrficient-onchip-uarts.patch
-cfag12864b-fix.patch
-slub-use-atomic_long_read-for-atomic_long-variables.patch
-slub-do-not-fail-on-broken-memory-configurations.patch
-rtc-max6902-minor-fixes.patch
-exec-kill-unsafe-bug_onsig-count-checks.patch
-xen-i386-xen-heads-fix-sections-mixup-update-2.patch
-check-for-ppc32-in-imsttfb.patch
-selectionh-add-tty_struct-forward-declaration.patch
-newport_con-warning-fix.patch
-i386-fix-lazy-mode-vmalloc-synchronization-for-paravirt.patch
-get_nodes-should-ignore-invalid-node.patch
-fix-ensure-we-dont-use-bootconsoles-after-init-has-been-released.patch
-au1100fb-move-au1100fb_fb_blank-beforce.patch
-pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-3x.patch
-remove-bdput-from-do_open-in-fs-block_devc.patch
-remove-bdput-from-do_open-in-fs-block_devc-fix.patch
-apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch
-enable-gpes-before-calling-_wak-on-resume.patch
-acpi-fix-a-warning-of-discarding-qualifiers-from-pointer-target-type.patch
-agk-dm-dm-rdac-fix-request-cmd_flags.patch
-gregkh-driver-sysfs-fix-locking-in-sysfs_lookup-and-sysfs_rename_dir.patch
-gregkh-driver-fix-off-by-one-in-sys-module-refcnt.patch
-gregkh-driver-howto-korean-translation-of-documentation-howto.patch
-gregkh-driver-howto-latest-lxr-url-address-changed.patch
-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
-fix-2-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
-fix-3-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
-fix-4-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
-disable-ioat.patch
-jdelvare-i2c-i2c-piix4-fix-ati-pci-ids.patch
-sn-add-support-for-cpu-disable.patch
-clean-up-duplicate-includes-in-drivers-input.patch
-iforce-warning-fix.patch
-drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
-clean-modulessymvers-in-external-module-dirs.patch
-scripts-ver_linux-correct-printing-of-binutils-version.patch
-improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
-ide-hpt366-fix-pci-clock-detection-for-hpt374.patch
-ide-hpt366-ultradma-filtering-for-sata-cards.patch
-mips-detect-bcm947xx-cpus.patch
-mips-bcm947xx-support.patch
-rfc-add-bcm947xx-to-kconfig.patch
-mips-add-bcm947xx-to-makefile.patch
-mips-irix_getcontext-will-always-fail-efault.patch
-drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
-drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
-git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
-mtdoops-printk-warning-fixes.patch
-pci-x-pci-express-read-control-interfaces-myrinet.patch
-dont-use-gfp_dma-for-zone-allocation.patch
-dm9000-fix-interface-hang-under-load.patch
-gregkh-pci-pci-move-prototypes-for-pci_bus_find_capability-to-include-linux-pcih.patch
-gregkh-pci-pci-quirk_e100_interrupt-called-too-early.patch
-gregkh-pci-pci-document-pci_iomap.patch
-gregkh-pci-pci-hotplug-cpqphp_ctrlc-remove-stale-bkl-use.patch
-gregkh-pci-pci-lets-kill-the-pci-hidden-behind-bridge-message.patch
-gregkh-pci-pci-make-pcie_get_readrq-visible-in-pcih.patch
-gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard-with-i810-chipset.patch
-pci-disable-decode-of-io-memory-during-bar-sizing.patch
-i386-add-support-for-picopower-irq-router.patch
-acpiphp_ibm-add-missing-n.patch
-sched-fix-broken-smt-mc-optimizations-with-cfs.patch
-sched-skip-updating-rqs-next_balance-under-null-sd.patch
-gregkh-usb-usb-cdc-acm-fix-sysfs-attribute-registration-bug.patch
-gregkh-usb-usb-visor-add-acer-s10-palm-device-id.patch
-gregkh-usb-usb-serial-garmin_gps-fixes-package-loss-if-used-from-gpsbabel.patch
-gregkh-usb-usb-stall-control-endpoint-when-file-storage-class-request-wvalue-0.patch
-gregkh-usb-usb-typo-usb_safe_padded-usb_serial_safe_padded.patch
-gregkh-usb-usb-u132-hcdc-fix-a-warning-when-config_pm-n.patch
-gregkh-usb-usb-fix-support-for-dell-wireless-broadband.patch
-gregkh-usb-usb-enable-hcd-support-on-sh-unconditionally.patch
-gregkh-usb-usb-r8a66597-hcd-fix-up-error-path.patch
-gregkh-usb-usb-quirks-multicard-reader-doesn-t-like-autosuspend.patch
-gregkh-usb-usb-support-for-the-evolution-scorpion-robots.patch
-gregkh-usb-usb-belkin_sa-avoid-divide-by-zero-error.patch
-gregkh-usb-usb-remove-debug-definition-from-dummy_hcd.patch
-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
-gregkh-usb-usb-blacklist-samsung-ml-2010-printer.patch
-gregkh-usb-usb-accept-1-byte-device-status-replies-fixing-some-b0rken-devices.patch
-gregkh-usb-usb-typo-in-usb-r8a66597-hcd-config.patch
-ohci-fix-oddball-gcc-warning.patch
-net-add-ath5k-wireless-driver.patch
-ath5k-printk-fix.patch
-ath5k-kconfig-fix.patch
-ath5k-needs-pci.patch
-x86_64-mm-install-unstripped-copies-on-disk.patch
-x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
-x86_64-mm-x86_64-vdso-install-unstripped-copies-on-disk.patch
-x86_64-mm-validate-against-acpi-motherboard-resources.patch
-x86_64-hpet-restore-vread.patch
-x86_64-restore-restore-nohpet-cmdline.patch
-x86_64-prep-idle-loop-for-dynticks.patch
-x86_64-enable-high-resolution-timers-and-dynticks.patch
-xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
-xtensa-consolec-remove-duplicate-include.patch
-pci-align-bar-settings-for-legacy-mode-ide.patch
-accounting-regression-since-rc1.patch
-sysfs-dont-warn-on-removal-of-a-nonexistent-binary-file.patch
-usb-storage-fix-bugs-in-the-disconnect-pathway.patch
-g_file_storage-fix-bug-in-dma-buffer-handling.patch
-i386-pci_get_device-called-from-interrupt-in-reboot-fixups.patch
-pnp-fix-up-after-lindent.patch
-pnpacpi-simplify-irq_flags.patch
-pnpacpi-remove-unnecessary-casts-of-void.patch
-isapnp-removed-unused-isapnp_detected-and-isapnp_debug.patch
-pnp-remove-module-infrastructure.patch
-pnp-remove-null-pointer-checks.patch

 Merged into mainline or a subsystem tree

-check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch

 Dropped

+quote-fix-infinite-loop.patch
+spi_mpc83xx-hang-fix.patch
+drivers-edac-fix-printk-level-down-to-debug-from-emerg.patch
+drivers-edac-fix-e752x-correct-return-code.patch
+bcm1480-serial-build-fix.patch
+pnp-remove-smcf010-quirk.patch
+update-gitignore.patch
+md-fix-some-bugs-with-growing-raid5-raid6-arrays.patch
+mntput-called-before-dput-in-afs.patch
+fix-dac960-driver-on-machines-which-dont-support-64-bit-dma.patch
+documentation-00-index-notice-ecryptfstxt-moved.patch
+x86_64-add-parenthesis-to-irq-vector-macros.patch
+h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable.patch

 2.6.23 queue

+acpi-clean-up-acpi_enter_sleep_state_prep.patch

 ACP fix

+alsa-cs5535audio-correctly-set-dma-substream.patch
+alsa-cs5535audio-fix-prd-register-save-restore-power-management-race.patch
+alsa-cs5535audio-update-pci-device-handling-in-suspend-resume.patch
+alsa-cs5535audio-fix-acc_bm_cmd-register-handling.patch
+alsa-cs5535audio-drop-unused-bus-master-stuff.patch

 alsa stuff

+arm-extern-inline-static-inline.patch
+arm-cleanup-struct-irqaction-initializers.patch
+documentation-arm-00-index-add-missing-entries.patch

 ARM

+cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
+cpufreq-implement-config_cpu_freq-stub-for.patch
+cpufreq_stats-misc-cpuinit-section-annotations.patch

 cpufreq

+git-powerpc-fixup.patch
+ppc-remove-apus-support.patch

 powerpc

+gregkh-driver-platform-prefix-modalias-with-platform.patch
+gregkh-driver-sysdev-remove-global-sysdev-drivers-list.patch
+gregkh-driver-sysfs-fix-i_mutex-locking-in-sysfs_get_dentry.patch
+gregkh-driver-sysfs-move-all-of-inode-initialization-into-sysfs_init_inode.patch
+gregkh-driver-sysfs-remove-sysfs_instantiate.patch
+gregkh-driver-sysfs-use-kill_anon_super.patch
+gregkh-driver-sysfs-make-sysfs_mount-static.patch
+gregkh-driver-sysfs-in-sysfs_lookup-don-t-open-code-sysfs_find_dirent.patch
+gregkh-driver-sysfs-simplify-readdir.patch
+gregkh-driver-sysfs-rewrite-sysfs_drop_dentry.patch
+gregkh-driver-sysfs-introduce-sysfs_rename_mutex.patch
+gregkh-driver-sysfs-simply-sysfs_get_dentry.patch
+gregkh-driver-sysfs-remove-s_dentry.patch
+gregkh-driver-sysfs-kill-sysfs_flag_removed.patch
+gregkh-driver-sysfs-rewrite-rename-in-terms-of-sysfs-dirents.patch
+gregkh-driver-sysfs-rewrite-sysfs_move_dir-in-terms-of-sysfs-dirents.patch
+gregkh-driver-ptycount-parm.patch
+gregkh-driver-sysfs-crash-debugging.patch

 driver tree

+revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
+make-kobject-dynamic-allocation-check-use-kallsyms_lookup.patch
+fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch

 driver-tree fixes

-git-dma.patch

 Dropped

+drm-via-invalid-device-ids-removal.patch

 drm fix

+v4l-stk11xx-add-a-new-webcam-driver.patch
+ivtv-fbc-bugfix.patch
+v4l-stk11xx-use-array_size-in-another-2-cases.patch
+v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
+v4l-stk11xx-add-static-to-tables.patch

 v4l things

+jdelvare-i2c-i2c-ibm_iic-numbered-adapter.patch
+jdelvare-i2c-i2c-davinci-new-bus-driver.patch

 i2c tree

+hwmon-coretemp-remove-bogus-__cpuinitdata-etc-cleanup.patch

 hwmon fix

+ia64-tree-wide-misc-__cpuinitdata-init-exit.patch

 ia64 fix

+ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch

 infiniband fix

+de-dosify-iforce-protocoltxt.patch

 input fix

+libata-correct-handling-of-srst-reset-sequences.patch
+libata-add-a-drivers-ide-style-dma-disable.patch
+ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
+ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch

 ata things

+ide-mpc8xx-only-build-mpc8xx-on-arch_ppc.patch
+ide-ide-fix-pci-refcounting.patch
+ide-pdc202xx_new-fix-pci-refcounting.patch
+ide-pdc202xx_new-switch-to-using-pci_get_slot-take-2.patch
+ide-hpt366-fix-pci-clock-detection-for-hpt374-take-4.patch
+ide-ide-add-ide_dev_is_sata-helper-take-2.patch
+ide-hpt366-ultradma-filter-for-sata-cards-take-2.patch
+ide-amd74xx-via82cxxx-dont-initialize-drive-dn.patch
+ide-amd74xx-remove-ide-proc-amd74xx.patch
+ide-ide-add-ide-hflag-no-atapi-dma.patch
+ide-ide-pci-add-ide-hflag-bootable-flag.patch
+ide-ide-pci-add-ide-hflag-no-dma-and-no-autodma-flags.patch
+ide-ide-remove-init-setup-dma-from-ide-pci-device-t.patch
+ide-ide-add-ide-hflag-no-lba48-and-ide-hflag-no-lba48-dma.patch
+ide-pdc202xx_old-remove-broken-swdma-support.patch
+ide-ide-add-mwdma-mask-and-swdma-mask-to-ide-pci-device-t.patch
+ide-pdc202xx_new-pll-detection-fix.patch
+ide-amd74xx-omit-pci_revision_id-read.patch
+ide-cmd64x-use-dev-revision.patch

 IDE tree updates

+mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch

 MIPS fix

-git-mmc-fixup.patch

 Unneeded

+git-mmc-fixup2.patch

 fix git-mmc

+ioc3-program-uart-predividers.patch
+sky2-fe-chip-support.patch
+sky2-use-debugfs-rename.patch
+sky2-document-gphy_ctrl-bits.patch
+sky2-dont-restrict-config-space-access.patch
+sky2-advanced-error-reporting.patch
+sky2-use-pci_config-access-functions.patch
+sky2-use-net_device-internal-stats.patch
+ktime_sub_ns-analog-of-ktime_add_ns.patch
+export-reciprocal_value-for-modules.patch
+sky2-hardware-receive-timestamp-counter.patch
+sky2-avoid-divide-in-receive-path.patch
+sky2-118.patch

 netdev things

+git-net-fixup.patch

 fix git-net

+net-atm-lecc-printk-warning-fix.patch
+e1000e-incorporate-napi_struct-changes-from-net-2624git.patch

 net fixes

+ocfs2-warning-fix.patch

 Fix git-ocfs2.patch

+move-a-few-definitions-to-au1000_xxs1500c-fix.patch

 Fix move-a-few-definitions-to-au1000_xxs1500c.patch

+8250_pci-autodetect-mainpine-cards.patch
+8250_pci-autodetect-mainpine-cards-fix.patch

 serial

+gregkh-pci-pci-aer-fix-warnings-when-pcieaer-n.patch
+gregkh-pci-pci-remove-devinit-from-pci_read_bridge_bases.patch
+gregkh-pci-pci-remove-__devinit-from-pcibios_get_irq_routing_table.patch
+gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard.patch
+gregkh-pci-pci-pci_get_device-call-from-interrupt-in-reboot-fixups.patch
+gregkh-pci-i386-add-support-for-picopower-irq-router.patch
+gregkh-pci-pci-disable-decode-of-io-memory-during-bar-sizing.patch
+gregkh-pci-pci-add-missing-pci-capability-ids.patch

 PCI tree updates

+fix-ide-legacy-mode-resources.patch
+fix-ide-legacy-mode-resources-fix.patch

 PCI fix

+sh-cleanup-struct-irqaction-initializers.patch
+sh64-cleanup-struct-irqaction-initializers.patch

 sh fixes

+drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch
+drivers-scsi-immc-fix-check-after-use.patch
+hptiop-add-new-firmware-interface-and-more-pci-device-ids.patch

 scsi

+git-block-fixup.patch
+git-block-fix-headers_check.patch
+ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch

 Fix git-block.patch

+gregkh-usb-usb-oti6858-remove-broken-ioctl-code-in-mm-tree-and-also-the-broken-fixes.patch
+gregkh-usb-usb-missing-test-for-eshutdown-in-adutux-driver.patch
+gregkh-usb-usb-ark3116c-fix-check-after-use.patch
+gregkh-usb-usb-remove-unnecessary-tests-in-isp116x-and-sl811.patch
+gregkh-usb-ueagle-eagle-iv-chipset-support.patch
+gregkh-usb-ueagle-devolo-and-elsa-chipsets-support.patch
+gregkh-usb-ueagle-allow-user-to-choose-input-interface-alternate-setting.patch
+gregkh-usb-ueagle-avoid-keyboard-driver-blocking.patch
+gregkh-usb-ueagle-do-not-sleep-when-device-is-disconnected.patch
+gregkh-usb-ueagle-cosmetic.patch
+gregkh-usb-usb-ehci-restart-speedup.patch
+gregkh-usb-usb-minor-fixes-for-r8a66597-driver.patch
+gregkh-usb-usb-remove-iso-status-value-in-uhci-hcd.patch
+gregkh-usb-usb-centralize-eremoteio-handling.patch
+gregkh-usb-usb-add-urb-unlinked-field.patch
+gregkh-usb-usb-ftdi_sio-handle-ft232rl-devices-like-ft232bm-devices.patch
+gregkh-usb-usb-fix-mistake-in-usb_hcd_giveback_urb.patch
+gregkh-usb-usb-avoid-the-donelist-after-an-error-in-ohci-hcd.patch
+gregkh-usb-usb-cp2101-coding-style-police.patch
+gregkh-usb-usb-kobil_sct-rework-driver.patch
+gregkh-usb-usb-less-restrictive-command-checking-in-g-file-storage.patch
+gregkh-usb-usb-berry-charge-memory-leak.patch
+gregkh-usb-usb-serial-show-port-number-in-sysfs.patch
+gregkh-usb-usb-usbmon-doc-update-mention-new-wildcard-bus.patch
+gregkh-usb-usb-avoid-redundant-cast-of-kmalloc-return-value-in-oti-6858-driver.patch
+gregkh-usb-usb-serial-pl2303-support-for-benq-siemens-mobile-phone-ef81.patch
+gregkh-usb-usb-reorganize-urb-status-use-in-dummy-hcd.patch
+gregkh-usb-usb-reorganize-urb-status-use-in-ehci-hcd.patch
+gregkh-usb-usb-reorganize-urb-status-use-in-ohci-hcd.patch
+gregkh-usb-usb-reorganize-urb-status-use-in-sl811-hcd.patch
+gregkh-usb-usb-reorganize-urb-status-use-in-r8a66597-hcd.patch
+gregkh-usb-usb-reorganize-urb-status-use-in-usbmon.patch
+gregkh-usb-usb-eliminate-urb-status-usage.patch
+gregkh-usb-usb-get-rid-of-urb-lock.patch
+gregkh-usb-usb-remove-traces-of-urb-status-from-usbcore.patch
+gregkh-usb-usb-driver-for-ch341-usb-serial-adaptor.patch
+gregkh-usb-usb-iphone-charge.patch

 USB tree updates

+9p-build-fix.patch
+9p-is-bust.patch
+9p-is-still-bust.patch

 git-v9fs.patch is busted

+x86_64-mm-cflags-probe.patch
+x86_64-mm-validate-against-acpi-motherboard-resources.patch
+x86_64-mm-vdso-install-unstripped-copies-on-disk.patch
+x86_64-mm-vdso-do-something-more-with-unstripped-copies-on-disk.patch
+x86_64-mm-fix-section-mismatch-warnings.patch
+x86_64-mm-mm-init-indent.patch
+x86_64-mm-fix-leak-of-__-kernel-from-top-level-directory-in-makefile.patch
+x86_64-mm-msr-cpuinit.patch
+x86_64-mm-cpuid-cpuinit.patch

 x86 tree updates

+fix-x86_64-mm-unwinder.patch

 Fix it

-x86_64-dynticks-disable-hpet_id_legsup-hpets.patch

 Dropped

+intel_cacheinfo-misc-section-annotation-fixes.patch
+intel_cacheinfo-misc-section-annotation-fixes-fix.patch
+intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
+x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch
+i386-stop-bogus-nmi-softlockup-warnings-in-show_mem.patch
+clockevents-remove-unused-inline-function.patch
+clockevents-allow-build-without-runtime-use.patch
+x86_64-consolidate-tsc-calibration.patch
+i386-prepare-sharing-hpet-code.patch
+i386-hpet-add-x8664-hpet-bits.patch
+i386-prepare-sharing-pit-code.patch
+x86_64-use-i386-i8253-h.patch
+x86_64-preparatory-apic-set-lvtt.patch
+x86_64-apic-remove-bogus-pit-synchronization.patch
+x86_64-apic-shuffle-calibration-around.patch
+x86_64-apic-calibration-remove-divisor.patch
+x86_64-apic-change-setup-calling-convention.patch
+x86_64-apic-remove-nested-irq-disable.patch
+x86_64-prep-idle-loop-for-dynticks.patch
+x86_64-apic-add-clockevents-functions.patch
+x86_64-convert-to-clockevents.patch
+x86_64-remove-unused-code.patch
+x86_64-cleanup-apic-c.patch
+jiffies-remove-unused-macros.patch
+acpi-remove-the-useless-ifdef-code.patch
+i386-pit-remove-the-useless-ifdefs.patch
+i386-hpet-sharing-optimize.patch
+ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
+ich-force-hpet-restructure-hpet-generic-clock-code.patch
+ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
+ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
+ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
+ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
+ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
+ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
+ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
+hpet-force-enable-on-ich34.patch
+hpet-force-enable-on-vt8235-37-chipsets.patch
+hpet-force-enable-on-vt8235-37-chipsets-fix.patch
+x86-fix-cpu_to_node-references.patch
+x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
+x86-convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
+x86-convert-cpu_sibling_map-to-be-a-per-cpu-variable-broke-ia64.patch
+x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
+x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
+x86-acpi-use-cpu_physical_id.patch
+i386-visws-extern-inline-static-inline.patch
+i386-cleanup-struct-irqaction-initializers.patch
+x86_64-cleanup-struct-irqaction-initializers.patch

 x86 things

+git-xfs-build-fix.patch

 Fix git-xfs.patch

+enforce-noreplace-smp-in-alternative_instructions.patch
+paravirt-fix-preemptible-lazy-mode-bug.patch
+i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch

 probable 2.6.23 queue

+fix-the-max-path-calculation-in-radix-treec-update.patch

 Fix fix-the-max-path-calculation-in-radix-treec.patch

+mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
+introduce-write_begin-write_end-aops-fix2.patch
+implement-simple-fs-aops-fix.patch
+ext2-convert-to-new-aops-fix2.patch
+ext3-convert-to-new-aops-fix-fix.patch
+ext4-convert-to-new-aops-fix-fix.patch
+gfs2-convert-to-new-aops-fix.patch
+reiserfs-convert-to-new-aops-fix2.patch
+hostfs-convert-to-new-aops-fix-fix.patch
+ufs-convert-to-new-aops-fix2.patch
+sysv-convert-to-new-aops-fix2.patch
+minix-convert-to-new-aops-fix2.patch
+affs-convert-to-new-aops-fix-fix.patch
+memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
+memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
+memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
+update-n_high_memory-node-state-for-memory-hotadd.patch
+slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch
+slub-do-not-use-page-mapping.patch
+slub-move-page-offset-to-kmem_cache_cpu-offset.patch
+slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
+slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch
+slub-optimize-cacheline-use-for-zeroing.patch
+memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
+capabilities-reset-current-pdeath_signal-when-increasing-capabilities.patch

 MM stuff

+frv-cleanup-struct-irqaction-initializers.patch

 frv cleanup

+hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
+hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
+hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
+hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch

 power management

+m32r-cleanup-struct-irqaction-initializers.patch

 m32r cleanup

+cris-cleanup-struct-irqaction-initializers.patch

 cris cleanup

+uml-dont-use-glibc-asm-userh.patch
+uml-floating-point-signal-delivery-fixes.patch
+uml-ptrace-floating-point-fixes.patch
+uml-coredumping-floating-point-fixes.patch
+uml-sysrq-and-mconsole-fixes.patch
+uml-style-fixes-in-fp-code.patch
+uml-eliminate-floating-point-state-from-register-file.patch

 uml update

+v850-cleanup-struct-irqaction-initializers.patch

 v850 cleanup

+i-oat-new-device-ids.patch
+i-oat-rename-the-source-file.patch
+i-oat-code-cleanup-from-checkpatch-output.patch
+i-oat-split-pci-startup-from-dma-handling-code.patch
+i-oat-add-support-for-msi-and-msi-x.patch
+dca-add-direct-cache-access-driver.patch
+i-oat-add-dca-services.patch

 ioat tree

+pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch

 Fix pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch

+jsm-remove-further-unneeded-crud-fix.patch

 Fix jsm-remove-further-unneeded-crud.patch

+pie-executable-randomization-fix-3.patch

 Fix pie-executable-randomization.patch even more

+use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch

 Fix use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch

+autofs4-reinstate-negatitive-timeout-of-mount-fails-fix.patch

 Fix autofs4-reinstate-negatitive-timeout-of-mount-fails.patch

+wait_task_stopped-continued-remove-unneeded-p-signal-=-null-check.patch
+console-events-and-accessibility.patch
+console-events-and-accessibility-fix.patch
+add-vmcoreinfo.patch
+maintainters-use-our-mail-list-as-blackfin-arch-maintainters.patch
+shrink-task_struct-if-config_futex=n.patch
+ttyh-remove-dead-define.patch
+fix-a-trivial-typo-in-scripts-checkstackpl.patch
+move-preempt_notifiers-into-an-always-included-kconfig.patch
+floppy-tolerate-dma-channel-unavailability.patch
+cleanup-floppyh.patch
+remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
+codingstyle-relax-the-80-cole-rule.patch
+script-to-check-for-undefined-kconfig-symbols.patch
+nbd-set-uninitialized-devices-to-size-0.patch
+nbd-allow-hung-network-i-o-to-be-cancelled.patch
+cciss-fix-error-reporting-for-sg_io.patch
+drop-some-headers-from-mmh.patch
+remove-include-asm-ipch.patch
+n_hdlcc-fix-check-after-use.patch
+kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
+make-kernel-profilectime_hook-static.patch
+drivers-block-ccissc-fix-check-after-use.patch
+#track-accurate-idle-time-with-tick_schedidle_sleeptime.patch: needs acks
+track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
+remove-valueless-definition-of-hard-selected-ramfs-option.patch
+local_t-documentation-update-2.patch
+atomic_opstxt-mention-local_t.patch
+local_t-update-documentation.patch
+docs-ramdisk-initrd-initramfs-corrections.patch
+remove-final-traces-of-long-deprecated-ramdisk-kernel.patch
+send-quota-messages-via-netlink.patch
+make-dmapool-code-use-__set_current_state.patch
+add-a-rounddown_pow_of_two-routine-to-log2h.patch
+fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch

 misc

+spi-driver-runtime-footprint-shrinkage.patch

 spi tweak

+kprobes-support-kretprobe-blacklist.patch

 kprobes update

+drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch

 Fix drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch

+atyfb-atyfb-unshare-pseudo_palette.patch
+fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
+fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
+vt-fix-warnings-in-selectionh.patch
+fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
+s3c2410fb-source-code-improvements.patch
+s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
+s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
+s3c2410fb-make-use-of-default_display-settings.patch
+cirrusfb-checkpatchpl-cleanup.patch
+cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
+cirrusfb-remove-typedefs.patch
+cirrusfb-remove-fields-from-cirrusfb_info.patch
+cirrusfb-code-improvements.patch
+cirrusfb-code-improvement-2nd-part.patch
+pm3fb-header-file-cleanup.patch
+pm2fb-hardware-cursor-support-for-the-permedia2.patch
+pm2fb-panning-and-hardware-cursor-fixes.patch
+vfb-make-virtual-framebuffer-mmapable.patch

 fbdev

+md-software-raid-autodetect-dev-list-not-array.patch
+md-software-raid-autodetect-dev-list-not-array-fix.patch

 RAID

+do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
+migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch

 fix cpu hotplug patches in -mm

+pnp-dont-fail-device-init-if-no-dma-channel.patch

 pnp fix

-mm-implement-swap-prefetching.patch
-memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch
 #
-add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
-rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch

 dropped

-sysctl-error-on-bad-sysctl-tables.patch
-sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
 #
-sysctl-update-sysctl_check_table.patch
+sysctl-parport-remove-binary-paths-fix.patch
-sysctl-clean-up-the-sched-debug-sysctl-usage.patch
-sysctl-update-sysctl_checks-list-of-binary-paths.patch
+sysctl-properly-register-the-irda-binary-sysctl-numbers.patch
+sysctl-error-on-bad-sysctl-tables.patch
+sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
+sysctl-update-sysctl_check_table.patch
+sysctl-update-sysctl_checks-list-of-binary-paths.patch
+sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code.patch
+sysctl-for-irda-update-sysctl_checks-list-of-binary-paths.patch
+sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion.patch

 udpate -mm sysctl patches

+mxser-remove-commented-crap.patch

 mxser cleanup

+task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
+task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch

 Fix task-containersv11-shared-container-subsystem-group-arrays.patch

+pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another.patch
+pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces.patch
+isolate-some-explicit-usage-of-task-tgid-fix.patch
+isolate-some-explicit-usage-of-task-tgid-fix-fix.patch

 fix other container stuff

+memory-controller-add-documentation.patch
+memory-controller-resource-counters-v7.patch
+memory-controller-resource-counters-v7-fix.patch
+memory-controller-containers-setup-v7.patch
+memory-controller-accounting-setup-v7.patch
+memory-controller-memory-accounting-v7.patch
+memory-controller-task-migration-v7.patch
+memory-controller-add-per-container-lru-and-reclaim-v7.patch
+memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
+memory-controller-oom-handling-v7.patch
+memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
+memory-controller-make-page_referenced-container-aware-v7.patch

 memory containment

+char-moxa-cleanup-prints.patch
+char-moxa-function-names-cleanup.patch
+char-moxa-remove-sleep_on.patch

 char driver cleanups

+remove-bits_to_type-macro.patch
+remove-bits_to_type-macro-fix.patch

 cleanup

+use-helpers-to-obtain-task-pid-in-printks.patch
+use-helpers-to-obtain-task-pid-in-printks-arch-code.patch
+remove-unused-variables-from-fs-proc-basec.patch
+use-task_pid_nr-in-ip_vs_syncc.patch
+redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
+x86-msr-driver-misc-cpuinit-annotations.patch
+i386-cpuid-misc-cpuinit-annotations.patch
+hotplug-cpu-migrate-a-task-within-its-cpuset.patch
+hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
+hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
+bitops-introduce-lock-ops.patch
+alpha-fix-bitops.patch
+alpha-lock-bitops.patch
+ia64-lock-bitops.patch
+mips-fix-bitops.patch
+mips-lock-bitops.patch
+powerpc-lock-bitops.patch
+bit_spin_lock-use-lock-bitops.patch
+fs-cramfs-inodec-remove-unused-variable.patch
+fs-cramfs-inodec-replace-hardcoded-value-with-preprocessor-constant.patch
+fs-cramfs-inodec-remove-error-variable.patch
+reiser4-use-helpers-to-obtain-task-pid-in-printks.patch

 various stuff

-acpi_format_exception-debug.patch

 dropped



All 1628 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/patch-list


