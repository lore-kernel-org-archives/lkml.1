Return-Path: <linux-kernel-owner+w=401wt.eu-S1763624AbXF0Wb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763624AbXF0Wb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759790AbXF0Wbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:31:49 -0400
Received: from [212.12.190.30] ([212.12.190.30]:33021 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759064AbXF0Wbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:31:48 -0400
From: Al Boldi <a1426z@gawab.com>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Please release a stable kernel Linux 3.0
Date: Thu, 28 Jun 2007 01:32:23 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200706271653.58870.a1426z@gawab.com> <20070627171149.GZ21478@ftp.linux.org.uk>
In-Reply-To: <20070627171149.GZ21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200706280132.23739.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Jun 27, 2007 at 04:53:58PM +0300, Al Boldi wrote:
> > Al Viro wrote:
> > > On Wed, Jun 27, 2007 at 11:18:36AM +0200, Zolt?n HUBERT wrote:
> > > > And as I understand it, this is (was ?) the whole point of
> > > > stable/development kernels. "We" can trust a newer stable
> > > > kernel to be a drop-in replacement for an older stable
> > > > kernel (from the same series), while development kernels
> > > > need time to stabilise with the new whizz-bang-pfouit stuff
> > > > that you all so nicely add.
> > >
> > > "Drop-in" in which sense?  That out-of-tree modules keep working?
> > > Not really...
> >
> > Al, be reasonable.  There are many out-of-tree GPL modules that won't be
> > accepted into mainline, never mind those that shouldn't be accepted. 
> > But these modules do have a right to not be obsoleted by constant API
> > changes.
>
> Modules do not have any rights; it's software...

Ok, this should have been read as kernel/module dev/user right to leverage 
each others code under GPL and out of good-will to yield an increased 
harvest.

> > You are effectively inhibiting the development of an out-of-tree GPL
> > module pool, by constantly pulling the rug under that community.
>
> The same thing happens with any yet-to-be-merged code.
>
> > Do you think this is fair?
>
> Yes, it is fair.  Decision to maintain your code out of tree indefinitely
> is your decision.

It's not my decision, it's the kernel maintainers decision to reject 
inclusion for one reason or another.  One reason could be a simple "we don't 
think this is useful".

Also, I think it's unrealistic to expect thousands of little-used modules to 
be included into mainline.

But, should we hinder that community to grow?


Thanks!

--
Al

