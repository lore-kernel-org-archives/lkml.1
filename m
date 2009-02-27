Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZB0KO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZB0KO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZB0KOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:14:48 -0500
Received: from nn7.de ([85.214.94.156]:39208 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbZB0KOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:14:47 -0500
Subject: Re: [Bug #12613] [Suspend regression][DRM, RADEON]
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: etienne <etienne.basset@numericable.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>
In-Reply-To: <200902252358.10362.rjw@sisk.pl>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
	 <vP9hdyF4fL.A.WIF.xpzoJB@chimera> <49A39A2D.7020007@numericable.fr>
	 <200902252358.10362.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 27 Feb 2009 11:14:32 +0100
Message-Id: <1235729672.25340.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 23:58 +0100, Rafael J. Wysocki wrote:
> On Tuesday 24 February 2009, etienne wrote:
> > Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12613
> > > Subject		: [Suspend regression][DRM, RADEON]
> > > Submitter	: etienne <etienne.basset@numericable.fr>
> > > Date		: 2009-01-28 22:00 (27 days old)
> > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
> > > References	: http://marc.info/?l=linux-kernel&m=123318030419558&w=4
> > > 		  http://marc.info/?l=linux-kernel&m=123334865404574&w=4
> > > 		  http://lkml.org/lkml/2009/2/8/203
> > > Patch		: http://lkml.org/lkml/2009/2/15/28
> > > 
> > > 
> > > 
> > hello,
> > 
> > no it's gone, I see Dave sent a modified version of my patch (thanks!)
> > you can close the bug as far as i m concerned

On my macbook pro I had a hang today on resume from s2ram (on
git-current and back to running compiz). I will now try without
compositing for some time (and metacity) to see if it is the cause.

Soeren
