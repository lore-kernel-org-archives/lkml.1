Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbZCOKft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbZCOKft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZCOKfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:35:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42999 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbZCOKfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:35:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [Bug #12806] i915 broken STR
Date: Sun, 15 Mar 2009 11:35:27 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, Eric Anholt <eric@anholt.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.LaD.u4BvJB@chimera> <1237088154.4064.0.camel@brick>
In-Reply-To: <1237088154.4064.0.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151135.28108.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009, Harvey Harrison wrote:
> On Sat, 2009-03-14 at 20:05 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12806
> > Subject		: i915 broken STR
> > Submitter	: Harvey Harrison <harvey.harrison@gmail.com>
> > Date		: 2009-02-28 4:20 (15 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5669fcacc58bf3a7386057addffd280d75380858
> > References	: http://marc.info/?l=linux-kernel&m=123579487801064&w=4
> > 
> > 
> 
> You can close this, turns out KMS got enabled in my config and userspace
> was too old to cope.

Thanks, closed.

Rafael
