Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZG1VCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZG1VCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZG1VCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:02:15 -0400
Received: from kroah.org ([198.145.64.141]:32824 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbZG1VCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:02:14 -0400
Date: Tue, 28 Jul 2009 14:01:21 -0700
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090728210121.GB12155@kroah.com>
References: <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
 <20090728174213.5e927428@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
 <20090728180649.596c5412@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
 <20090728195651.3a402a31@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
 <20090728201553.0eb2d51d@lxorguk.ukuu.org.uk>
 <20090728195648.GA4833@kroah.com>
 <20090728204720.GF31679@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728204720.GF31679@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 04:47:20PM -0400, Theodore Tso wrote:
> On Tue, Jul 28, 2009 at 12:56:48PM -0700, Greg KH wrote:
> > 
> > Do you have a pointer to your previous queue before you zapped it so
> > that others might be able to pick it up?
> > 
> 
> It's also available from linux-next as commit:
> 
>      024ea7873598686f3e02002ca23c2e8fa3fddd30

Hm, that's the wrong end of the tree, I think you mean
fbfa97a856a4ce2fa86058cff84f589eb7f1364e, right?

thanks,

greg k-h
