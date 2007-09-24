Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbXIXJRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbXIXJRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 05:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXIXJRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 05:17:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36625 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054AbXIXJRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 05:17:31 -0400
Date: Mon, 24 Sep 2007 02:17:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc7-mm1
Message-Id: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/

- New git tree git-powerpc-galak.patch added to the -mm lineup: ppc32
  things, mainly (Kumar Gala <galak@gate.crashing.org>)



Boilerplate:

- See the `hot-fixes' directory for any important updates to this patchset.

- To fetch an -mm tree using git, use (for example)

  git-fetch git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git tag v2.6.16-rc2-mm1
  git-checkout -b local-v2.6.16-rc2-mm1 v2.6.16-rc2-mm1

- -mm kernel commit activity can be reviewed by subscribing to the
  mm-commits mailing list.

        echo "subscribe mm-commits" | mail majordomo@vger.kernel.org

- If you hit a bug in -mm and it is not obvious which patch caused it, it is
  most valuable if you can perform a bisection search to identify which patch
  introduced the bug.  Instructions for this process are at

        http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt

  But beware that this process takes some time (around ten rebuilds and
  reboots), so consider reporting the bug first and if we cannot immediately
  identify the faulty patch, then perform the bisection search.

- When reporting bugs, please try to Cc: the relevant maintainer and mailing
  list on any email.

- When reporting bugs in this kernel via email, please also rewrite the
  email Subject: in some manner to reflect the nature of the bug.  Some
  developers filter by Subject: when looking for messages to read.

- Occasional snapshots of the -mm lineup are uploaded to
  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/ and are announced on
  the mm-commits list.



Changes since 2.6.23-rc6-mm1:

 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-arm.patch
 git-audit-master.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-powerpc-galak.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-jg-misc.patch
 git-kbuild.patch
 git-kvm.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-net.patch
 git-backlight.patch
 git-battery.patch
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
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-kgdb.patch
 git-block-vs-reiser4.patch
 git-nfsd-broke-reiser4.patch

 git trees

-fix-dac960-driver-on-machines-which-dont-support-64-bit-dma-fix.patch
-uml-use-correct-type-in-blkgetsize-ioctl.patch
-atyfb-force-29mhz-xtal-on-g3-powerbooks.patch
-fix-failure-to-resume-from-initrds.patch
-fix-uts-corruption-during-cloneclone_newuts.patch
-rtc-ds1742c-should-use-resource_size_t-for-base-address.patch
-rtc-rtc-ds1553c-should-use-resource_size_t-for-base.patch
-mspec-handle-shrinking-virtual-memory-areas.patch
-mspec-handle-shrinking-virtual-memory-areas-3.patch
-pci-fix-unterminated-pci_device_id-lists.patch
-pci-fix-unterminated-pci_device_id-lists-fix.patch
-xen-dont-bother-trying-to-set-cr4.patch
-intelfb-fix-bug-in-dpll-disable.patch
-intel-agp-fix-i830-mask-variable-that-changed-with-g33-support.patch
-dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs.patch
-nfs-fix-oops-re-sysctls-and-v4-support.patch
-disable-sys_timerfd-for-2623.patch
-ext34-ensure-do_split-leaves-enough-free-space-in-both-blocks.patch
-kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
-convert-uid-hash-to-hlist.patch
-fix-user-namespace-exiting-oops.patch
-fix-numa-memory-policy-reference-counting.patch
-git-alsa-sc6000-build-fix.patch
-ess-maestro-1-2-2e-sound-card-use-list_for_each_entry.patch
-routines-for-effect-processor-fx8010-use-list_for_each_entry.patch
-arm-unbalanced-parenthesis-fix.patch
-ppc-remove-apus-support.patch
-fix-gregkh-driver-sysfs-spit-a-warning-to-users-when-they-try-to-create-a-duplicate-sysfs-file.patch
-drivers-char-nozomic-__devexit_p-usage-build-fix.patch
-i2c-i801-documentation-patch-for-intel-tolapai.patch
-i2c-i801-smbus-patch-for-intel-tolapai.patch
-i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
-ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
-ahci-raid-mode-sata-patch-for-intel-tolapai.patch
-st340823a-hpa-and-libata.patch
-ata-increase-allowed-config-flags.patch
-ata_piix-replace-spaces-with-tabs.patch
-ide-ide-remove-ide-rate-filter-from-speedproc.patch
-ide-ide-use-only-set-pio-mode-for-programming-pio-modes.patch
-ide-ide-remove-ide-dma-check.patch
-ide-ide-add-mwdma-mask-and-swdma-mask-to-ide-pci-device-t.patch
-git-net-fix-2.patch
-nit-net-skge-build-fix.patch
-git-net-af_iucv-fixes.patch
-git-net-sgiseeq-fix.patch
-git-net-fix-ibmveth.patch
-git-net-af_iucv-fixes.patch
-git-net-sgiseeq-fix.patch
-git-net-fix-ibmveth.patch
-sky2-118.patch
-sb1250-macc-de-typedef-de-volatile-de-etc.patch
-net_sb1250_mac-update-kconfig-entry.patch
-net_sb1250_mac-rename-to-sb1250_mac.patch
-ipg-add-ip1000a-driver-to-kernel-tree.patch
-git-net-broke-ipg-add-ip1000a-driver-to-kernel-tree.patch
-use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
-git-block-fix-u14-34f.patch
-ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
-x86_64-mm-fix-section-mismatch-warnings.patch
-therm_throtc-fix-section-mismatch.patch
-i386-cpuid_count-fix-argument-signedness-warnings.patch
-i386-fix-section-mismatch-warning-in-intelc.patch
-x86-misc-constifications.patch
-x86-constify-wd_ops.patch
-x86-multi-byte-single-instruction-nops.patch
-enforce-noreplace-smp-in-alternative_instructions.patch
-i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
-scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host.patch
-x86_64-nx-bit-handling-in-change_page_attr.patch
-driver-core-fix-deprectated-sysfs-structure-for-nested-class-devices.patch
-pvrusb2-hdw-terminate-usb-device-id-table-differently.patch
-cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch

 Merged into mainline or a subsystem tree

+ufs-fix-sun-state.patch
+fix-potential-oops-in-generic_setlease.patch
+fix-potential-oops-in-generic_setlease-v2.patch
+fix-mspec-handle-shrinking-virtual-memory-areas.patch
+missing-null-termination-in-one-wire-uevent.patch
+typo-fix-kernel-config-option.patch

 2.6.23 queue

+fix-oops-in-platform-uevent.patch

 Also 2.6.23 I guess

-git-acpi-fixup.patch

 Unneeded

+acpi-sbs-fix-sbs-add-alarm-patch.patch

 ACPI fix

+agk-dm-dm-ioctl-fix-compat-bounds-test.patch
+agk-dm-dm-tidy-bio_io_error-usage.patch
+agk-dm-dm-ioctl-remove-vmalloc-void-cast.patch
+agk-dm-dm-crypt-use-per-device-singlethread-workqueues.patch
+agk-dm-dm-crypt-add-post-processing-queue.patch

 device mapped tree updates

+fix-3-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
+kobject-temporarily-save-k_name-on-cleanup-for-debug-message.patch

 Fix Greg's driver core tree

+jdelvare-i2c-i2c-i801-tolapai-support.patch

 i2c tree update

 Dropped

+first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
+first-stab-at-elantech-touchpad-driver-for-26226-testers-fix.patch
+make-wistron-btns-recognize-special-keys-on-medion-wim2160-notebooks.patch

 Input stuff

+menuconfig-distinguish-between-selected-by-another-options-and-comments.patch

 Kconfig

+pata_acpi-use-ata_sff_port_start.patch

 pata update

+libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
+ahci-add-mcp79-support-to-ahci-driver.patch
+ahci-add-mcp79-support-to-ahci-driver-update.patch

 ata updates

+ide-ide-call-udma_filter-before-resorting-to-the-ultradma-mask.patch
+ide-ide-remove-ide-rate-filter-from-speedproc-take-2.patch
+ide-ide-use-only-set-pio-mode-for-programming-pio-modes-take-2.patch
+ide-ide-remove-ide-dma-check-take-2.patch
+ide-ide-add-mwdma-mask-and-swdma-mask-to-ide-pci-device-t-take-2.patch
+ide-alim15x3-fix-cd_rom-dma-and-pio-fifo-settings-setup.patch
+ide-alim15x3-use-host-flags-and-udma-mask-fields-from-ide-pci-device-t.patch
+ide-aec62xx-remove-aec62xx-dma-lost-irq.patch
+ide-siimage-separate-pata-and-sata-methods.patch
+ide-ide-add-fixup-method-to-ide-hwif-t.patch
+ide-ide-add-ide-device-add.patch
+ide-maintainers-mark-ide-scsi-as-orhpan.patch
+ide-ide-add-ide-find-port-helper.patch
+ide-ide-remove-redundant-comments-from-ide-h.patch
+ide-ide-add-config-ide-arch-obsolete-init.patch

 IDE tree updates

+git-mtd-vs-powerpc.patch

 Fix mtd borkage

+git-net-fix-macec.patch
+git-net-sky2-fixups.patch
+git-net-fix-wireless-kconfig.patch
+git-net-fix-spidernet-build.patch
+spider_net_ethtool-keep-up-with-recent-netdev-stats-changes.patch
+pasemi_mac-build-fix-after-recent-netdev-stats.patch
+make-mv643xx_ethc-build-again.patch
+dgrs-remove-from-build-config-and-maintainer-list.patch

 net fixes

+phylib-spinlock-fixes-for-softirqs.patch
+forcedeth-power-down-phy-when-interface-is-down.patch
+forcedeth-no-link-is-informational.patch
+phylib-irq-event-workqueue-handling-fixes.patch
+phylib-fix-an-interrupt-loop-potential-when-halting.patch

 netdev updates

+git-battery.patch
+revert-git-battery.patch

 Greg's driver tree breaks this git tree

-git-nfsd-fixup.patch

 Unneeded

+provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
+serial_txx9-use-upf_fixed_port.patch

 serial stuff

+some-proc-entries-are-missed-in-sched_domain-sys_ctl-debug.patch

 sched fix

+mpt-fusion-shut-up-uninitialized-variable.patch
+mptbase-reset-ioc-initiator-during-pci-resume.patch

 scsi fixes

+usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch

 USB fix

+9p-fix-compile-error-if-config_sysctl.patch

 9pfs fix

-git-net-vs-git-wireless.patch
-git-net-vs-git-wireless-2.patch
-ath5k-panic-fix.patch
-git-net-vs-git-wireless-3.patch
-git-net-broke-git-wireless.patch
-more-wireless-borkage.patch
-more-wireless-borkage-2.patch
-more-wireless-borkage-3.patch
-git-wireless-fix-99.patch

 more wireless churn, getting sorted out now.  b44 is still disabled in -mm,
 perhaps unjustly.

+x86_64-mm-misc_-constifications.patch
+x86_64-mm-constify-stacktrace_ops.patch
+x86_64-mm-unwinder-default.patch
+x86_64-mm-less-stack-alignment.patch
+x86_64-mm-fix-argument-signedness-warnings.patch
+x86_64-mm-cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
+x86_64-mm-die-lock.patch
+x86_64-mm-mce-setup.patch
+x86_64-mm-fix-off-by-one-in-find_next_zero_string.patch
+x86_64-mm-fix-4-bit-apicid-assumption-of-mach-default.patch
+x86_64-mm-fix-section-mismatch.patch
+x86_64-mm-fix-section-mismatch-warning-in-intel_c.patch
+x86_64-mm-constify-wd_ops.patch
+x86_64-mm-multi-byte-single-instruction-nops.patch
+x86_64-mm-introduce-used_vectors-bitmap-which-can-be-used-to-reserve-vectors.patch
+x86_64-mm-configure-hpet_emulate_rtc-automatically.patch
+x86_64-mm-also-show-non-zero-irq-counts-for-vectors-that-currently-dont-have-a-handler.patch
+x86_64-mm-avoid-temporarily-inconsistent-pte-s.patch
+x86_64-mm-return-correct-error-code-from-child_rip-in-x86_64-entry_s.patch
+x86_64-mm-agp-flush.patch
+x86_64-mm-aout-regs.patch
+x86_64-mm-remove-fpu-port.patch

 x86 tree updates

+agp-fix-race-condition-between-unmapping-and-freeing-pages.patch

 AGP fix

+convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch

 Fix convert-cpu_sibling_map-to-a-per_cpu-data-array.patch even more

+x86_64-nx-bit-handling-in-change_page_attr.patch

 x86 fix

+kgdb-fix-help-text.patch
+kgdb-fix-docbook-and-kernel-doc-typos.patch

 kgdb updates

+usb-dont-propagate-freeze-or-prethaw-suspends.patch
+ppp_mppe-dont-put-interimkey-on-the-stack.patch

 Maybe 2.6.23 material

+mm-use-pagevec-to-rotate-reclaimable-page.patch
+mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
+git-nfs-vs-nfs-convert-to-new-aops-fix.patch
+slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab-fix.patch
+fix-memory-hot-remove-not-configured-case.patch
+fix-memory-hot-remove-not-configured-case-fix.patch
+mm-per-device-dirty-threshold-fix.patch

 MM updates

+oom-move-prototypes-to-appropriate-header-file.patch
+oom-move-constraints-to-enum.patch
+oom-change-all_unreclaimable-zone-member-to-flags.patch
+oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
+oom-add-per-zone-locking.patch
+oom-serialize-out-of-memory-calls.patch
+oom-add-oom_kill_allocating_task-sysctl.patch
+oom-suppress-extraneous-stack-and-memory-dump.patch
+oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
+oom-do-not-take-callback_mutex.patch
+oom-do-not-take-callback_mutex-fix.patch

 oom-killer work

+alpha-beautify-vmlinuxlds.patch

 alpha cleanup

+tty-bring-the-old-cris-driver-back-somewhere-into-the.patch

 cris update

+uml-stop-saving-process-fp-state-fix.patch

 Fix uml-stop-saving-process-fp-state.patch

+uml-rename-pt_regs-general-purpose-register-file-fix.patch

 Fix uml-rename-pt_regs-general-purpose-register-file.patch

+uml-eliminate-hz.patch
+uml-fix-timer-switching.patch
+uml-simplify-interval-setting.patch
+uml-separate-timer-initialization.patch
+uml-generic_time-support.patch
+uml-generic_clockevents-support.patch
+uml-clocksource-support.patch
+uml-clocksource-support-fix.patch
+uml-tickless-support.patch
+uml-tickless-support-fix.patch
+uml-eliminate-interrupts-in-the-idle-loop.patch
+uml-eliminate-sigalrm.patch
+uml-use-sec_per_sec-constants.patch

 UML updates

-remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch

 Dropped

+keys-make-request_key-and-co-fundamentally-asynchronous-update.patch
+keys-missing-word-in-documentation.patch

 Fix keys-make-request_key-and-co-fundamentally-asynchronous.patch

+jbd-slab-cleanups-2.patch
+jbd-slab-cleanups-3.patch

 Fix jbd-slab-cleanups.patch

+shrink_dcache_sb-speedup.patch
+add-consts-where-appropriate-in-fs-nls.patch
+reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch
+reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
+unify-dma_bit_mask-definitions-v31.patch
+delete-gcc-295-compatible-structure-definition.patch
+fs-isofs-nameic-remove-uninitialized-local-vars-warning.patch
+ide-cd-is-unmaintained.patch
+tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
+tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
+kernel-printkc-concerns-about-the-console-handover.patch
+atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
+udf-code-style-fixup-v3.patch
+aio-dont-confuse-debug-define-location.patch
+userc-deinline.patch
+userc-ifdef-mq_bytes.patch
+userc-ifdef-mq_bytes-fix.patch

 Misc

+isdn-hisax-hfc_usbc-fix-check-after-use.patch

 ISDN fix

+ecryptfs-remove-header_extent_size.patch
+ecryptfs-remove-assignments-in-if-statements.patch
+ecryptfs-read_writec-routines.patch
+ecryptfs-replace-encrypt-decrypt-and-inode-size-write.patch
+ecryptfs-set-up-and-destroy-persistent-lower-file.patch
+ecryptfs-update-metadata-read-write-functions.patch
+ecryptfs-make-open-truncate-and-setattr-use-persistent-file.patch
+ecryptfs-convert-mmap-functions-to-use-persistent-file.patch
+ecryptfs-convert-mmap-functions-to-use-persistent-file-fix.patch
+ecryptfs-initialize-persistent-lower-file-on-inode-create.patch
+ecryptfs-remove-unused-functions-and-kmem_cache.patch
+ecryptfs-replace-magic-numbers.patch

 ecryptfs update (ugly, can't think of a better way, needs better review)

+radeonfb-xpress-200m-rc410-support-patch.patch
+drivers-video-pmag-ba-fbc-improve-diagnostics.patch
+drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch

 fbdev updates

+ext4-uninitialized-block-groups.patch
+ext4-uninitialized-block-groups-fix.patch
+introduce-ext4_find_next_bit.patch
+ext4-fix-sparse-warnings.patch
+ext4-flex_bg-kernel-support-v2.patch

 ext4 stuff

+ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
+knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch
+reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
+unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
+vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
+nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch
+cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits.patch

 VFS attributes work

+r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
+r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly.patch
+r-o-bind-mounts-give-permission-a-local-mnt-variable.patch
+r-o-bind-mounts-create-cleanup-helper-svc_msnfs.patch
+r-o-bind-mounts-stub-functions.patch
+r-o-bind-mounts-elevate-write-count-opend-files.patch
+r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
+r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
+r-o-bind-mounts-make-access-use-mnt-check.patch
+r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
+r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
+r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
+r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
+r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
+r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
+r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
+r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
+r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
+r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
+r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
+r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
+r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
+r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
+r-o-bind-mounts-do_rmdir-elevate-write-count.patch
+r-o-bind-mounts-track-number-of-mount-writers.patch
+r-o-bind-mounts-track-number-of-mount-writers-hack-hack-hack.patch
+r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch

 read-only bind mounts

+add-a-missing-00-index-file-for-documentation-vm-fix.patch

 Fix add-a-missing-00-index-file-for-documentation-vm.patch

+remove-broken-netfilter-binary-sysctls-from-bridging-code.patch

 sysctl fixes

+make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch

 Fix make-access-to-tasks-nsproxy-lighter.patch

-isolate-some-explicit-usage-of-task-tgid-fix.patch
-isolate-some-explicit-usage-of-task-tgid-fix-fix.patch

 Folded into isolate-some-explicit-usage-of-task-tgid.patch

+memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch

 Fix memory-controller-oom-handling-v7.patch

+mem-controller-gfp-mask-fix.patch

 Fix memory-controller patches in -mm.

+ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
+ipc-integrate-ipc_checkid-into-ipc_lock-fix-3.patch

 Fix ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch

+ipc_fix_wrong_comments.patch

 Fix ipc comments

+extended-crashkernel-command-line.patch
+use-extended-crashkernel-command-line-on-i386.patch
+use-extended-crashkernel-command-line-on-x86_64.patch
+use-extended-crashkernel-command-line-on-ia64.patch
+use-extended-crashkernel-command-line-on-ppc64.patch
+use-extended-crashkernel-command-line-on-sh.patch
+add-documentation-for-extended-crashkernel-syntax.patch

 kdump stuff

+cleanup-macros-for-distinguishing-mandatory-locks.patch
+gfs2-cleanup-explicit-check-for-mandatory-locks.patch
+9pfs-cleanup-explicit-check-for-mandatory-locks.patch
+afs-cleanup-explicit-check-for-mandatory-locks.patch
+nfs-cleanup-explicit-check-for-mandatory-locks.patch
+rework-proc-locks-via-seq_files-and-seq_list-helpers.patch
+rework-proc-locks-via-seq_files-and-seq_list-helpers-fix.patch
+rework-proc-locks-via-seq_files-and-seq_list-helpers-fix-2.patch

 file locking rework

+exportfs-add-fid-type.patch
+exportfs-add-new-methods.patch
+ext2-new-export-ops.patch
+ext3-new-export-ops.patch
+ext4-new-export-ops.patch
+efs-new-export-ops.patch
+jfs-new-export-ops.patch
+ntfs-new-export-ops.patch
+xfs-new-export-ops.patch
+fat-new-export-ops.patch
+isofs-new-export-ops.patch
+shmem-new-export-ops.patch
+reiserfs-new-export-ops.patch
+gfs2-new-export-ops.patch
+ocfs2-new-export-ops.patch
+exportfs-remove-old-methods.patch
+exportfs-make-struct-export_operations-const.patch
+exportfs-update-documentation.patch

 nfsd export rework


5392 commits in 2031 patch files


All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/patch-list


