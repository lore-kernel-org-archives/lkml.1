Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbYCUR5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbYCUR5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYCUR5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:57:08 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41416 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbYCUR5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:57:07 -0400
Date: Fri, 21 Mar 2008 19:56:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's with the "pre-releases" directory?
Message-ID: <20080321175651.GC1434@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.00.0803211312500.30701@localhost.localdomain> <20080321173415.GB1434@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0803211336350.7227@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803211336350.7227@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 01:41:36PM -0400, Robert P. J. Day wrote:
> On Fri, 21 Mar 2008, Adrian Bunk wrote:
> 
> > On Fri, Mar 21, 2008 at 01:13:45PM -0400, Robert P. J. Day wrote:
> > >
> > >   just curious about this:
> > >
> > > ftp://ftp.kernel.org/pub/linux/kernel/v2.6/pre-releases
> >
> > These were the -test kernels that preceeded 2.6.0.
> >
> > > given that it seems filled with really old 2.6.0 content, what's the
> > > value in it?  just curious.
> >
> > just curious about this:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/Historic
> >
> > given that it seems filled with really old content, what's the
> > value in it?  just curious.
> >
> > ;-)
> 
> um ... i'm going to assume you were being facetious since i can
> certainly see the value in the very, very first "official" release of
> linux, while still not seeing the point in a directory labelled
> "pre-releases" which contains nothing but pre-2.6.0 patches that go
> back to 2003.  on the other hand, that *would* make sense under the
> Historic directory.

We even have
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/old-test-kernels/

The directory you spotted contains the pre-releases of 2.6 .

When is something historic and when might people search for it at the 
old place?

But considering that one dir doesn't harm much I don't think there's 
much point discussing it further.

> rday
> 
> p.s.  and while i'm whining, would it be possible to clear the
> obsolete "LATEST-IS" files out of:
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/v2.6/testing
> 
> i have a script that grabs the latest rc tarball out of that
> directory, and it got confused by seeing more than one LATEST-IS file.
> not hard to work around but, still ...

For this you have to whine to the guy who places them there:

-rw-rw-r--  1 torvalds kernel         0 Mar  5 04:44 LATEST-IS-2.6.25-rc4
-rw-rw-r--  1 torvalds kernel         0 Mar 10 05:30 LATEST-IS-2.6.25-rc5
-rw-rw-r--  1 torvalds kernel         0 Mar 16 23:50 LATEST-IS-2.6.25-rc6

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

