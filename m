Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbXF0RL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbXF0RL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXF0RLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:11:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37832 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbXF0RLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:11:50 -0400
Date: Wed, 27 Jun 2007 18:11:49 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
Message-ID: <20070627171149.GZ21478@ftp.linux.org.uk>
References: <200706271653.58870.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706271653.58870.a1426z@gawab.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 04:53:58PM +0300, Al Boldi wrote:
> Al Viro wrote:
> > On Wed, Jun 27, 2007 at 11:18:36AM +0200, Zolt?n HUBERT wrote:
> > > And as I understand it, this is (was ?) the whole point of
> > > stable/development kernels. "We" can trust a newer stable
> > > kernel to be a drop-in replacement for an older stable
> > > kernel (from the same series), while development kernels
> > > need time to stabilise with the new whizz-bang-pfouit stuff
> > > that you all so nicely add.
> >
> > "Drop-in" in which sense?  That out-of-tree modules keep working?
> > Not really...
> 
> Al, be reasonable.  There are many out-of-tree GPL modules that won't be 
> accepted into mainline, never mind those that shouldn't be accepted.  But 
> these modules do have a right to not be obsoleted by constant API changes.

Modules do not have any rights; it's software, for fsck sake...
 
> You are effectively inhibiting the development of an out-of-tree GPL module 
> pool, by constantly pulling the rug under that community.

The same thing happens with any yet-to-be-merged code.
 
> Do you think this is fair?

Yes, it is fair.  Decision to maintain your code out of tree indefinitely
is your decision.
