Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbZFAUMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbZFAUMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbZFAUMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:12:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55933 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbZFAUMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:12:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Angel <angel@pearlgates.net>
Subject: Re: [Bug #12947] r128: system hangs when X is started with DRI enabled
Date: Mon, 1 Jun 2009 22:13:04 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Jos van der Ende" <seraph@xs4all.nl>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <PkPeJtNB3KO.A.CSH.sWbIKB@chimera> <20090531105227.178e5397.angel@pearlgates.net>
In-Reply-To: <20090531105227.178e5397.angel@pearlgates.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012213.04940.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 May 2009, Angel wrote:
> On Sat, 30 May 2009 21:55:34 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12947
> > Subject		: r128: system hangs when X is started with DRI enabled
> > Submitter	: Jos van der Ende <seraph@xs4all.nl>
> > Date		: 2009-03-26 16:14 (66 days old)
> 
> 
> We've found a working bug fix for 2.6.29 which I expect will be included in the next bug fix release. However, 2.6.30-rc[1-7] (which already includes this fix) introduced a new problem which we're still working on.
> 
> The bug fix in question is this one:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=42beefc00

Thanks, closed.

Best,
Rafael
