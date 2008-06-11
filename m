Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYFKWCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYFKWCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbYFKWCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:02:05 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.112]:3465 "EHLO
	mail86-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750746AbYFKWCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:02:04 -0400
X-Greylist: delayed 1870 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2008 18:02:04 EDT
X-BigFish: VPS-12(zz7efV11e3izz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <48504408.8060905@am.sony.com>
Date: Wed, 11 Jun 2008 14:30:48 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>
Subject: [announce] PS3 Linux Distributor's Starter Kit (v1.8) released
References: <4581CA0C.20102@am.sony.com> <47A3AF1E.5040308@am.sony.com>
In-Reply-To: <47A3AF1E.5040308@am.sony.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2008 21:30:48.0950 (UTC) FILETIME=[6A8E2960:01C8CC0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An updated PS3 Linux Distributor's Starter Kit (v1.8) was released.

The CD-ROM image CELL-Linux-CL_20080609-ADDON.iso (189 MiB) is here:

  ftp://ftp.infradead.org/pub/Sony-PS3/
  http://ftp.uk.linux.org/pub/linux/Sony-PS3/

The changes list follows. 

-Geoff


----------
v1.8 (2008/06/09 version)

 ALL

  o Following specs are changed

    - Update Linux kernel version to 2.6.25.4. This kernel is build from 
      http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.25.4.tar.bz2 and
      additional PS3 patches. Please refer to the 'patches' directory in 
      'src/linux-2.6.25.4-20080609.tar.bz2' for details.

    - Update perfmon2 to the latest version

    - Update the PS3 utilities to the latest version

    - Update kexec tools to the latest version


 Kboot

  o Following spec are changed

    - Update Linux kernel version to 2.6.25.4

    - Update the PS3 utilities and kexec tools to the latest version


 Linux Kernel

  o Following specs are changed

    - The wireless ethernet now serves wlan0 instead of eth1.  Both wired
      and wireless interfaces still share one MAC address, hence do not connect
      them to the same network segment.

    - The wireless ethernet now supports precise WPA(IE) information. PS3
      system software version 2.20 or later is required for this.

    - Wake-on-LAN support has been added. PS3 system software version 2.20
      or later is required for this.

  o Known problems

    - There's a bug in the CD-ROM media change code in kernel 2.6.25.
      Please access CD/DVD/BD media within 30 seconds after the media change,
      else I/O errors may occur.


 Library/Commands

    - Commands for perfmon2 are updated to the latest version

    - Kexec tools is updated to the latest version


 Documents

    - Wireless extension for GbE section of Linux Kernel Overview is
      updated

    - The descriptions for ps3-dump-bootloader and ps3-rtc-init command
      are added to Platform Specific Utilities.


    - "Linux Kernel Overview", "How to Use Linux on PS3",
      "Platform Specific Utilities", and "How to Enable Your Distro" have
      been updated.

-EOF



