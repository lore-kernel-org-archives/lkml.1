Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYCRNds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYCRNds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 09:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYCRNdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 09:33:36 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:60266 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410AbYCRNde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 09:33:34 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <200803181403.37969.bzolnier@gmail.com> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <alpine.LFD.1.00.0803171548480.3020@woody.linux-foundation.org> <20080318001831.575D093C911@tippex.mynet.homeunix.org> <200803181403.37969.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Tue, 18 Mar 2008 14:03:36 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 18 Mar 2008 14:32:59 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080318133259.E71EE2DC044@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1Jbbw8-00081m-5P.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Jbbw8-00081m-5P 855eafc4d62b936580904e49541367e2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bzolnier@gmail.com said:
> Could you also add printk() to task_in_intr()? 

Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=1, tf->command=236
Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 14:18:26 tippex task_in_intr: hda: stat=50


