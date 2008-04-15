Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbYDOVKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbYDOVKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbYDOVKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:10:44 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:35724 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYDOVKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:10:43 -0400
Date: Wed, 16 Apr 2008 00:09:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug #10117] 2.6.25-current-git sometimes hangs on boot -
	dual-core Sony Vaio
Message-ID: <20080415210931.GE1677@cs181133002.pp.htv.fi>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <200804152233.39079.rjw@sisk.pl> <20080415204500.GD1677@cs181133002.pp.htv.fi> <200804152303.45320.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200804152303.45320.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 11:03:44PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, 15 of April 2008, Adrian Bunk wrote:
> > On Tue, Apr 15, 2008 at 10:33:38PM +0200, Rafael J. Wysocki wrote:
> > > 
> > > I dropped the bug from the list of recent regressions, so it doesn't block
> > > bug #9832 any more.  However, this still is a bug and regression, so the
> > > bugzilla entry remains open.
> > 
> > Soerens original report was a 2.6.25 regression.
> > 
> > And #10377 that was closed as a duplicate of #10117 was also reported as 
> > a 2.6.25 regression.
> > 
> > #10117 seems to suffer from the common disease of people hijacking an 
> > existing bug, but Soeren's issue that was what was originally tracked in 
> > #10117 is (or was) a 2.6.25 regression.
> 
> Well, I'm really not 100% sure it was a regression from 2.6.24 and I'm not
> sure bug #10377 should have been marked as a duplicate.

Soeren said in [1] "note that I've never seen these hangs on 2.6.24*".

> I made bug #10117 block bug #9832 again, but it would be nice to sort this out.
> 
> Why do we think that the cause of bugs #10117 and #10377 is the same?

Venki Pallipadi has to answer this.

> Rafael

cu
Adrian

[1] http://lkml.org/lkml/2008/2/24/15

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

