Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYKTU4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYKTU4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYKTUw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:52:59 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:58559 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbYKTUw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:52:57 -0500
Date: Thu, 20 Nov 2008 12:52:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 20 (staging* [lots])
Message-Id: <20081120125240.149af529.randy.dunlap@oracle.com>
In-Reply-To: <20081120212907.efc2276b.sfr@canb.auug.org.au>
References: <20081120212907.efc2276b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4925CE1C.010D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 21:29:07 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20081119:
> 
> Undropped trees:
> 	driver-core
> 	usb
> 	staging

drivers/staging/agnx/pci.c:327: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
drivers/staging/agnx/pci.c:328: error: 'struct ieee80211_if_conf' has no member named 'ssid'
drivers/staging/agnx/pci.c:328: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
drivers/staging/agnx/pci.c:329: error: 'struct ieee80211_if_conf' has no member named 'ssid'
drivers/staging/agnx/pci.c:329: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
drivers/staging/agnx/pci.c:330: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
drivers/staging/agnx/pci.c:331: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
drivers/staging/agnx/pci.c:331: error: 'struct ieee80211_if_conf' has no member named 'ssid'
drivers/staging/agnx/pci.c:331: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
drivers/staging/agnx/pci.c:331: error: 'struct ieee80211_if_conf' has no member named 'ssid'
drivers/staging/agnx/pci.c:331: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
(r6260 & r6298 & r6300)

drivers/staging/rt2860/rt_profile.c:928: error: 'struct task_struct' has no member named 'fsuid'
drivers/staging/rt2860/rt_profile.c:929: error: 'struct task_struct' has no member named 'fsgid'
drivers/staging/rt2860/rt_profile.c:930: error: 'struct task_struct' has no member named 'fsuid'
drivers/staging/rt2860/rt_profile.c:930: error: 'struct task_struct' has no member named 'fsgid'
drivers/staging/rt2860/rt_profile.c:1554: error: 'struct task_struct' has no member named 'fsuid'
drivers/staging/rt2860/rt_profile.c:1555: error: 'struct task_struct' has no member named 'fsgid'
(r6265)

(.text+0x5e0): multiple definition of `comedi_unmap'
(r6272 & r6297 & r6259)

asus_oled.c:(.text+0x164fb4): undefined reference to `usb_bulk_msg'
asus_oled.c:(.text+0x16508d): undefined reference to `usb_bulk_msg'
asus_oled.c:(.text+0x1651ef): undefined reference to `usb_put_dev'
asus_oled.c:(.text+0x1652f3): undefined reference to `usb_bulk_msg'
asus_oled.c:(.text+0x1654eb): undefined reference to `usb_get_dev'
asus_oled.c:(.text+0x1655b0): undefined reference to `usb_put_dev'
asus_oled.c:(.init.text+0xcb01): undefined reference to `usb_register_driver'
asus_oled.c:(.exit.text+0x1acb): undefined reference to `usb_deregister'
(r6261)

drivers/staging/meilhaus/me0600_device.o: WARNING: referencing weak function me0600_pci_constructor for mcount
drivers/staging/meilhaus/me0900_device.o: WARNING: referencing weak function me0900_pci_constructor for mcount
drivers/staging/meilhaus/me1400_device.o: WARNING: referencing weak function me1400_pci_constructor for mcount
drivers/staging/meilhaus/me4600_device.o: WARNING: referencing weak function me4600_pci_constructor for mcount
drivers/staging/meilhaus/me6000_device.o: WARNING: referencing weak function me6000_pci_constructor for mcount
drivers/staging/meilhaus/me8100_device.o: WARNING: referencing weak function me8100_pci_constructor for mcount
(r6263)

drivers/staging/comedi/proc.c:89: error: redefinition of 'comedi_proc_init'
drivers/staging/comedi/comedidev.h:368: error: previous definition of 'comedi_proc_init' was here
drivers/staging/comedi/proc.c:98: error: redefinition of 'comedi_proc_cleanup'
drivers/staging/comedi/comedidev.h:371: error: previous definition of 'comedi_proc_cleanup' was here
(r6287)

(.init.text+0x0): multiple definition of `init_module'
(.text+0x1d1d): multiple definition of `me_dlock_lock'
(.text+0x1c5b): multiple definition of `me_dlist_deinit'
(.text+0x1ca4): multiple definition of `me_dlist_get_device'
(.exit.text+0x0): multiple definition of `cleanup_module'
(.text+0x20fc): multiple definition of `me_slist_add_subdevice_tail'
(.text+0x2123): multiple definition of `me_slist_deinit'
(.text+0x1ebc): multiple definition of `me_dlock_enter'
(.text+0x226c): multiple definition of `me_slock_deinit'
(.text+0x22f4): multiple definition of `me_slock_lock'
(.init.text+0x0): multiple definition of `init_module'
(.text+0x20f0): multiple definition of `me_slist_query_number_subdevices'
(.text+0x2112): multiple definition of `me_slist_init'
(.text+0x1d04): multiple definition of `me_dlock_deinit'
(.text+0x1fb6): multiple definition of `me_subdevice_deinit'
(.text+0x1c4a): multiple definition of `me_dlist_init'
(.text+0x220a): multiple definition of `me_slist_get_subdevice'
(.text+0x226d): multiple definition of `me_slock_init'
(.text+0x1c34): multiple definition of `me_dlist_add_device_tail'
(.text+0x222f): multiple definition of `me_slist_del_subdevice_tail'
(.text+0x1c30): multiple definition of `me_dlist_get_number_devices'
(.text+0x2285): multiple definition of `me_slock_enter'
(.text+0x1c28): multiple definition of `me_dlist_query_number_devices'
(.text+0x1cc9): multiple definition of `me_dlist_del_device_tail'
(.text+0x1fbf): multiple definition of `me_subdevice_init'
(.text+0x20f8): multiple definition of `me_slist_get_number_subdevices'
(.text+0x86): multiple definition of `me_device_deinit'
(.text+0x1f04): multiple definition of `me_dlock_exit'
(.text+0xbd): multiple definition of `me_device_pci_init'
(.text+0x216c): multiple definition of `me_slist_get_subdevice_by_type'
(.text+0x1d05): multiple definition of `me_dlock_init'
(.text+0x22cd): multiple definition of `me_slock_exit'
(.text+0x1d1d): multiple definition of `me_dlock_lock'
(.text+0x1c5b): multiple definition of `me_dlist_deinit'
(.text+0x1ca4): multiple definition of `me_dlist_get_device'
(.exit.text+0x0): multiple definition of `cleanup_module'
(.text+0x20fc): multiple definition of `me_slist_add_subdevice_tail'
(.text+0x2123): multiple definition of `me_slist_deinit'
(.text+0x1ebc): multiple definition of `me_dlock_enter'
(.text+0x226c): multiple definition of `me_slock_deinit'
(.text+0x22f4): multiple definition of `me_slock_lock'
(.init.text+0x0): multiple definition of `init_module'
(.text+0x20f0): multiple definition of `me_slist_query_number_subdevices'
(.text+0x2112): multiple definition of `me_slist_init'
(.text+0x1d04): multiple definition of `me_dlock_deinit'
(.text+0x1fb6): multiple definition of `me_subdevice_deinit'
(.text+0x1c4a): multiple definition of `me_dlist_init'
(.text+0x220a): multiple definition of `me_slist_get_subdevice'
(.text+0x226d): multiple definition of `me_slock_init'
(.text+0x1c34): multiple definition of `me_dlist_add_device_tail'
(.text+0x222f): multiple definition of `me_slist_del_subdevice_tail'
(.text+0x1c30): multiple definition of `me_dlist_get_number_devices'
(.text+0x2285): multiple definition of `me_slock_enter'
(.text+0x1c28): multiple definition of `me_dlist_query_number_devices'
(.text+0x1cc9): multiple definition of `me_dlist_del_device_tail'
(.text+0x1fbf): multiple definition of `me_subdevice_init'
(.text+0x20f8): multiple definition of `me_slist_get_number_subdevices'
(.text+0x86): multiple definition of `me_device_deinit'
(.text+0x1f04): multiple definition of `me_dlock_exit'
(.text+0xbd): multiple definition of `me_device_pci_init'
(.text+0x216c): multiple definition of `me_slist_get_subdevice_by_type'
(.text+0x1d05): multiple definition of `me_dlock_init'
(.text+0x22cd): multiple definition of `me_slock_exit'
make[4]: *** [drivers/staging/meilhaus/built-in.o] Error 1
(r6291)


Let me know if/which .config files are needed.

---
~Randy
