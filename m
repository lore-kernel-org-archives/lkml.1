Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXC3VcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXC3VcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932178AbXC3VcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:32:13 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38898 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932114AbXC3VcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:32:11 -0400
Date: Fri, 30 Mar 2007 23:32:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oliver Pinter <oliver.pntr@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, jgarzik@pobox.com,
       linux-ide@vger.kernel.org,
       Mathieu =?utf-8?Q?B=C3=A9rard?= <Mathieu.Berard@crans.org>,
       Tejun Heo <htejun@gmail.com>
Subject: [1/4] 2.6.21-rc5: known regressions (v2)
Message-ID: <20070330213209.GM14134@stusta.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : crashes in KDE
References : http://bugzilla.kernel.org/show_bug.cgi?id=8157
Submitter  : Oliver Pinter <oliver.pntr@gmail.com>
Status     : unknown


Subject    : hung bootup in various drivers
References : http://lkml.org/lkml/2007/3/30/68
Submitter  : Ingo Molnar <mingo@elte.hu>
Handled-By : Ingo Molnar <mingo@elte.hu>
             Greg KH <gregkh@suse.de>
             Kay Sievers <kay.sievers@vrfy.org>
Status     : problem is being discussed


Subject    : kernels fail to boot with drives on ATIIXP controller
             (ACPI/IRQ related)
References : https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229621
             http://lkml.org/lkml/2007/3/4/257
Submitter  : Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
Status     : unknown


Subject    : NCQ problem with ahci and Hitachi drive
References : http://lkml.org/lkml/2007/3/4/178
             http://lkml.org/lkml/2007/3/9/475
             http://lkml.org/lkml/2007/2/22/8
Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
Handled-By : Tejun Heo <htejun@gmail.com>
Patch      : http://lkml.org/lkml/2007/2/22/8
Status     : possible patch available



