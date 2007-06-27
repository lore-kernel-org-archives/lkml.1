Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbXF0Wc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbXF0Wc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762172AbXF0Wcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:32:52 -0400
Received: from [212.12.190.30] ([212.12.190.30]:33025 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761298AbXF0Wcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:32:50 -0400
From: Al Boldi <a1426z@gawab.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Please release a stable kernel Linux 3.0
Date: Thu, 28 Jun 2007 01:32:04 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200706271653.58870.a1426z@gawab.com> <20070627155254.GO1094@stusta.de>
In-Reply-To: <20070627155254.GO1094@stusta.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200706280132.04798.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
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
> "have a right" are strong words.
> Who is granting them this right?

Good-will GPL style.

> > You are effectively inhibiting the development of an out-of-tree GPL
> > module pool, by constantly pulling the rug under that community.
> >
> > Do you think this is fair?
>
> Why are these modules not submitted for inclusion into the kernel?

There are many reasons for this, but basically they are too under-developed 
to be included, and need more time to mature out-of-tree.


Thanks!

--
Al

