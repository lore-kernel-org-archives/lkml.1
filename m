Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbZJGUXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbZJGUXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760014AbZJGUXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:23:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37649 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759977AbZJGUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:23:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [Bug #14258] Memory leak in SCSI initialization
Date: Wed, 7 Oct 2009 22:24:00 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: kernel-testers@vger.kernel.org, James.Bottomley@suse.de,
       michael@ellerman.id.au, linux-kernel@vger.kernel.org
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910021926.46532.rjw@sisk.pl> <200910072304.BAB43294.JLOFHtSVMQOOFF@I-love.SAKURA.ne.jp>
In-Reply-To: <200910072304.BAB43294.JLOFHtSVMQOOFF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910072224.00467.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 October 2009, Tetsuo Handa wrote:
> Rafael J. Wysocki wrote:
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14258
> > > > Subject		: Memory leak in SCSI initialization
> > > > Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> > > > Date		: 2009-09-22 4:18 (10 days old)
> > > > References	: http://marc.info/?l=linux-kernel&m=125359311312243&w=4
> > > > Handled-By	: Michael Ellerman <michael@ellerman.id.au>
> > > > Patch		: http://patchwork.kernel.org/patch/49258/
> > 
> > Thanks for the update.
> http://patchwork.kernel.org/patch/49258/ would be replaced by
> an updated patch at http://lkml.org/lkml/2009/10/2/335

Thanks, updated.

Rafael
