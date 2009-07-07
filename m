Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZGGK7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZGGK7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 06:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbZGGK7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 06:59:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60972 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbZGGK7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 06:59:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [Bug #13318] AGP doesn't work anymore on nforce2
Date: Tue, 7 Jul 2009 13:00:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>,
       Jerome Glisse <glisse@freedesktop.org>,
       Karsten Mehrhoff <kawime@gmx.de>,
       Michel =?iso-8859-1?q?D=E4nzer?= <michel@daenzer.net>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.PDB.4BpUKB@chimera> <20090707021254.GA25184@sli10-desk.sh.intel.com>
In-Reply-To: <20090707021254.GA25184@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071300.12565.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Shaohua Li wrote:
> On Tue, Jul 07, 2009 at 08:00:36AM +0800, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13318
> > Subject		: AGP doesn't work anymore on nforce2
> > Submitter	: Karsten Mehrhoff <kawime@gmx.de>
> > Date		: 2009-04-30 8:51 (68 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59de2bebabc5027f93df999d59cc65df591c3e6e
> > References	: http://marc.info/?l=linux-kernel&m=124108156417560&w=4
> > Handled-By	: Shaohua Li <shaohua.li@intel.com>
> Can anybody else help look at this issue? I really have no idea why this could
> happens.

Quirky hardware?

Rafael
