Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbYFWRH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbYFWRH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbYFWRHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:07:13 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55253 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657AbYFWRHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:07:12 -0400
Date: Mon, 23 Jun 2008 20:05:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: rpeterso@redhat.com, cluster-devel@redhat.com,
       Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [Cluster-devel] Re: [Bug 10827] 2.6.26rc4 GFS2 oops.
Message-ID: <20080623170514.GA4756@cs181140183.pp.htv.fi>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <20080623151417.GA28779@cs181140183.pp.htv.fi> <1214235162.3724.71.camel@technetium.msp.redhat.com> <200806231902.16412.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200806231902.16412.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 07:02:15PM +0200, Rafael J. Wysocki wrote:
> On Monday, 23 of June 2008, Bob Peterson wrote:
> > > Yup, the patch in your Bugzilla is for code that is new in 2.6.26.
> > > 
> > > Can you push your patch for inclusion into 2.6.26 so that 2.6.26 won't 
> > > get released with this regression?
> > > 
> > > Thanks
> > > Adrian
> > 
> > Hi Adrian,
> > 
> > Unfortunately, I cannot.  All access to the gfs2 "-nmw" git tree is
> > controlled by Steve Whitehouse, and he is on vacation/holiday until
> > tomorrow.
> > 
> > I've submitted the patch to cluster-devel, so hopefully he'll push it
> > as soon as he returns tomorrow.
> 
> You can post the patch in this thread, with CC to Andrew Morton.

If Steve is on vacation only until tomorrow there's not a need to bypass
him - it's not that extremely urgent.

> Thanks,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

