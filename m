Return-Path: <linux-kernel-owner+w=401wt.eu-S932713AbXCUQMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbXCUQMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932798AbXCUQMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:12:55 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45194 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713AbXCUQMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:12:54 -0400
X-Originating-Ip: 74.108.131.3
Date: Wed, 21 Mar 2007 12:08:58 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Tasos Parisinos <t.parisinos@sciensis.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][NEW] crypto API: rsa algorithm module patch (kernel
 version 2.6.20.3)
In-Reply-To: <20070321090420.f46cef4f.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0703211207170.7576@localhost.localdomain>
References: <Pine.LNX.4.64.0703211701260.27640@zenon.ceid.upatras.gr>
 <20070321090420.f46cef4f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Randy Dunlap wrote:

> On Wed, 21 Mar 2007 17:13:31 +0200 (EET) Tasos Parisinos wrote:

> > +/*
> > + * mpi_alloc - allocate an mpi
> > + * @n: pointer pointer to the allocated mpi
> > + * @limbs: number of allocated limbs (32 bit digits)
> > + *
> > + * The allocated mpi will be zeroed and not canonicalized
> > + */


if this is extractable kernel doc content, shouldn't it begin with
"/**" rather than just "/*"?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
