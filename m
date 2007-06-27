Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbXF0NxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbXF0NxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 09:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXF0NxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 09:53:17 -0400
Received: from [212.12.190.29] ([212.12.190.29]:32929 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752135AbXF0NxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 09:53:16 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
Date: Wed, 27 Jun 2007 16:53:58 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271653.58870.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Jun 27, 2007 at 11:18:36AM +0200, Zolt?n HUBERT wrote:
> > And as I understand it, this is (was ?) the whole point of
> > stable/development kernels. "We" can trust a newer stable
> > kernel to be a drop-in replacement for an older stable
> > kernel (from the same series), while development kernels
> > need time to stabilise with the new whizz-bang-pfouit stuff
> > that you all so nicely add.
>
> "Drop-in" in which sense?  That out-of-tree modules keep working?
> Not really...

Al, be reasonable.  There are many out-of-tree GPL modules that won't be 
accepted into mainline, never mind those that shouldn't be accepted.  But 
these modules do have a right to not be obsoleted by constant API changes.

You are effectively inhibiting the development of an out-of-tree GPL module 
pool, by constantly pulling the rug under that community.

Do you think this is fair?


Thanks!

--
Al

