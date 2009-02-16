Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbZBPVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbZBPVlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZBPVld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:41:33 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:52824 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbZBPVlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:41:32 -0500
Date: Mon, 16 Feb 2009 22:40:26 +0100
To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
       ZhangRui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Message-ID: <20090216214026.GB8400@gamma.logic.tuwien.ac.at>
References: <20090213093354.GA10175@denkbrett.schottelius.org> <20090213094200.GC17774@elte.hu> <alpine.LFD.2.00.0902131302240.3671@localhost.localdomain> <1234775219.4998.1.camel@rzhang-desktop> <20090216105847.GA29302@denkbrett.schottelius.org> <20090216131351.GA4839@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216131351.GA4839@denkbrett.schottelius.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 16 Feb 2009, Nico Schottelius wrote:
> Same problem on 2.6.29-rc5:
> 
> [  121.149035] [drm] Initialized drm 1.1.0 20060810
> [  121.191392] pci 0000:00:02.0: power state changed by ACPI to D0
> [  121.191410] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [  121.191419] pci 0000:00:02.0: setting latency timer to 64
> [  121.251571] pci 0000:00:02.0: irq 30 for MSI/MSI-X
> [  121.251646] [drm] Initialized i915 1.6.0 20080730 on minor 0
> [  121.302429] [drm:i915_initialize] *ERROR* can not ioremap virtual address for ring buffer


I am having the same problem with brightness suddenly not working in rc5
and the same error message.

If you need dmesg/.config/something else let me know. Thanks

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
BARSTIBLEY
A humorous device such as a china horse or small naked porcelain
infant which jocular hosts use of piss water into your Scotch with.
			--- Douglas Adams, The Meaning of Liff
