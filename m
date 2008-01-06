Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbYAFQAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbYAFQAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYAFQAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:00:41 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41983 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045AbYAFQAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:00:40 -0500
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
In-Reply-To: <20080106154557.GK2082@does.not.exist>
References: <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
	 <20080102194030.GC11638@parisc-linux.org>
	 <1199304735.3258.53.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
	 <1199316785.3258.85.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
	 <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain>
	 <20080106144706.GA25419@elte.hu>
	 <1199632845.5205.31.camel@localhost.localdomain>
	 <20080106154557.GK2082@does.not.exist>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 10:00:33 -0600
Message-Id: <1199635234.5205.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-01-06 at 17:45 +0200, Adrian Bunk wrote:
> Bugzilla for tracking and mailing lists for discussing are not mutually 
> exclusive.

I didn't ever say they were.  What I said was we needed the work flow on
the mailing lists.

> What about asking the Bugzilla admins to set the default owner of new 
> SCSI bugs to linux-scsi@vger.kernel.org?
> 
> This way all SCSI bugs submitted in Bugzilla will automatically be 
> forwarded to the linux-scsi mailing list.

Well, I've only been asking for this for the last two years.  If you can
actually make it happen, I'd be eternally grateful.

James


