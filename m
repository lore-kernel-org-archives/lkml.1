Return-Path: <linux-kernel-owner+w=401wt.eu-S1763052AbYEFFwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763052AbYEFFwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYEFFwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:52:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848AbYEFFwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:52:07 -0400
Date: Mon, 5 May 2008 22:50:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>, linux-next@vger.kernel.org,
       sfrench@us.ibm.com, swhiteho@redhat.com, stefanr@s5r6.in-berlin.de,
       jeff@garzik.org, ralf@linux-mips.org, drzeus-list@drzeus.cx,
       jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com, ericvh@gmail.com,
       wim@iguana.be, chris@zankel.net, nico@cam.org, penberg@cs.helsinki.fi,
       clameter@sgi.com, ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: git trees which are not yet in linux-next
Message-Id: <20080505225009.46f7be15.akpm@linux-foundation.org>
In-Reply-To: <20080506144549.b06ded7c.sfr@canb.auug.org.au>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<1210006336.3923.26.camel@odin>
	<20080505105728.c8f7590a.akpm@linux-foundation.org>
	<20080506144549.b06ded7c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 14:45:49 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Mon, 5 May 2008 10:57:28 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Mon, 05 May 2008 17:52:16 +0100
> > Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:
> > 
> > > On Fri, 2008-05-02 at 15:12 -0700, Andrew Morton wrote:
> > > 
> > > > 
> > > > (This list is probably incomplete - there might be other trees which are
> > > > presently empty but which aren't in linux-next yet)
> > > 
> > > Any chance the voltage/current regulator tree could be added :-
> > > 
> > > ___git-regulator: git://opensource.wolfsonmicro.com/linux-2.6-audioplus.git#for-akpm
> > > 
> > 
> > Yup, I added that, thanks.
> 
> Was there a request in there for linux-next as well?  ;-)

I thought about it.  It's a once-off tree rather than a permanent thing. 
Do you do those?

Getting it into linux-next would of course give better testing coverage.
