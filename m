Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbZEZXMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbZEZXMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZEZXMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:12:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48489 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbZEZXMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:12:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [Bug #12765] i915 VT switch with AIGLX causes X lock up
Date: Wed, 27 May 2009 01:12:22 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, DRI <dri-devel@lists.sourceforge.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Michel =?iso-8859-1?q?D=E4nzer?= <michel@daenzer.net>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <WCcYF-TAbJC.A.9dE.cScGKB@chimera> <20090526222352.GA1532@sucs.org>
In-Reply-To: <20090526222352.GA1532@sucs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905270112.23559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 May 2009, Sitsofe Wheeler wrote:
> On Sun, May 24, 2009 at 09:31:15PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12765
> > Subject		: i915 VT switch with AIGLX causes X lock up
> > Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
> > Date		: 2009-02-21 15:38 (93 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=14d200c5e5bd19219d930bbb9a5a22758c8f5bec
> > References	: http://marc.info/?l=linux-kernel&m=123523074304955&w=4
> > 		  http://lkml.org/lkml/2009/4/27/317
> > Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Patch		: http://patchwork.kernel.org/patch/20197/
> 
> Yes this is still here in  2.6.30-rc7-00066-ge2a1b9e ...

Thanks for the update.

Rafael
