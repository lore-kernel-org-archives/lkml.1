Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099Ab0AKUBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0AKUBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947Ab0AKUBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:01:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab0AKUBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:01:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [Bug #14907] Commit "kbuild: fix bzImage build for x86" breaks build
Date: Mon, 11 Jan 2010 21:02:13 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Michal Marek <mmarek@suse.cz>,
       Oliver Hartkopp <oliver@hartkopp.net>, Sam Ravnborg <sam@ravnborg.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.lV.kNlSLB@chimera> <20100111013606.GA7031@progeny.tock>
In-Reply-To: <20100111013606.GA7031@progeny.tock>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112102.13570.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Jonathan Nieder wrote:
> Rafael J. Wysocki wrote:
> 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14907
> > Subject		: Commit "kbuild: fix bzImage build for x86" breaks build
> > Submitter	: Oliver Hartkopp <oliver@hartkopp.net>
> > Date		: 2009-12-19 19:21 (23 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4a2ff67c88211026afcbdbc190c13f705dae1b59
> > References	: http://marc.info/?l=linux-kernel&m=126125050622195&w=4
> > 		  http://marc.info/?l=linux-kernel&m=126114565103300&w=4
> > 		  http://marc.info/?l=linux-kbuild&m=126202819526623&w=2
> > Handled-By	: Jonathan Nieder <jrnieder@gmail.com>
> > Patch		: http://thread.gmane.org/gmane.linux.kbuild.devel/4313/focus=4319
> > 		  http://patchwork.kernel.org/patch/71957/
> 
> I am using the patch without problems, but it is not in the mainline
> as of v2.6.33-rc3-git3.  So please do keep the bug listed.

I will, thanks for the update.

Rafael
