Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbZJBM6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbZJBM6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbZJBM6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:58:07 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:53547 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757713AbZJBM6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:58:06 -0400
To: rjw@sisk.pl, James.Bottomley@SteelEye.com
Cc: michael@ellerman.id.au, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #14258] Memory leak in SCSI initialization
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	<COE24pZSBH.A.Vk.6MTxKB@chimera>
In-Reply-To: <COE24pZSBH.A.Vk.6MTxKB@chimera>
Message-Id: <200910022158.JBD48969.MOSVQOFHJOLtFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 2 Oct 2009 21:58:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
This memory leak might exist in all releases since 23 Sep 2005.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6f3a20242db2597312c50abc11f1e747c5d2326a
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
As of now, the patch is not yet merged into Linus's tree.
It still should be listed.
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14258
> Subject		: Memory leak in SCSI initialization
> Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Date		: 2009-09-22 4:18 (10 days old)
> References	: http://marc.info/?l=linux-kernel&m=125359311312243&w=4
> Handled-By	: Michael Ellerman <michael@ellerman.id.au>
> Patch		: http://patchwork.kernel.org/patch/49258/
> 
Regards.
