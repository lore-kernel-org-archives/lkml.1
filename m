Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbZJBRZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbZJBRZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757652AbZJBRZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:25:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35725 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627AbZJBRZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:25:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [Bug #14258] Memory leak in SCSI initialization
Date: Fri, 2 Oct 2009 19:26:46 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: James.Bottomley@steeleye.com, michael@ellerman.id.au,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.Vk.6MTxKB@chimera> <200910022158.JBD48969.MOSVQOFHJOLtFF@I-love.SAKURA.ne.jp>
In-Reply-To: <200910022158.JBD48969.MOSVQOFHJOLtFF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910021926.46532.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Tetsuo Handa wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> This memory leak might exist in all releases since 23 Sep 2005.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6f3a20242db2597312c50abc11f1e747c5d2326a
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> As of now, the patch is not yet merged into Linus's tree.
> It still should be listed.
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14258
> > Subject		: Memory leak in SCSI initialization
> > Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> > Date		: 2009-09-22 4:18 (10 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125359311312243&w=4
> > Handled-By	: Michael Ellerman <michael@ellerman.id.au>
> > Patch		: http://patchwork.kernel.org/patch/49258/

Thanks for the update.

Rafael
