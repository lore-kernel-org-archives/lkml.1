Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYAFS5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYAFS5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYAFS47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:56:59 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42075 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbYAFS46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:56:58 -0500
Date: Sun, 6 Jan 2008 20:56:25 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080106185625.GM2082@does.not.exist>
References: <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org> <1199316785.3258.85.camel@localhost.localdomain> <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org> <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain> <20080106144706.GA25419@elte.hu> <1199632845.5205.31.camel@localhost.localdomain> <20080106171158.GM20473@parisc-linux.org> <1199640983.5205.65.camel@localhost.localdomain> <20080106183402.GA7906@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080106183402.GA7906@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 07:34:02PM +0100, Willy Tarreau wrote:
>...
> As to using bugzilla for bug tracking... Well, I agree that bug
> tracking is important when you work on multiple problems at once.
> But bugzilla should be the developer's tool, not the end user's.
> That means that it should only be our job to create entries there
> if end users find it too difficult, and that we should just invite
> them to *try* to report there to save us some time.

Where does this opinion end users would find Bugzilla too difficult come 
from? Many other projects use Bugzilla without big problems.

Is this just plain FUD or based on real reports from end users?
In the latter case, please give pointers to them so that whatever 
problems exist can be fixed.

And different to LKML, you don't run into problems like majordomo 
silently dropping your email because it contains HTML or a vCard.

> Willy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

