Return-Path: <linux-kernel-owner+w=401wt.eu-S933906AbYEGW3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906AbYEGW3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933475AbYEGW2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:28:18 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:20600 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253AbYEGW2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:28:12 -0400
Message-ID: <48222C7C.2050807@googlemail.com>
Date: Thu, 08 May 2008 00:26:04 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: CONFIG_PRINTK_TIME broken on git HEAD ?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2008 22:19:12.0823 (UTC) FILETIME=[60F0C470:01C8B090]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've updated today to 2.6.26-rc1-00166-gc0a1811 , running an 64bit kernel at the moment.

dmesg shows here :

...


[    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 42756 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
[4294014.506571] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1010753
[4294014.506571] Kernel command line: root=/dev/sdb1 ro debug vga=0x317
[4294014.506571] Initializing CPU#0
[4294014.506571] Preemptible RCU implementation.
[4294014.506571] PID hash table entries: 4096 (order: 12, 32768 bytes) 

...                                                                                     


Is this a known issue ?


Regards,

Gabriel
 
