Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbZCSUPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbZCSUPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbZCSUOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:14:21 -0400
Received: from kroah.org ([198.145.64.141]:35703 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755669AbZCSUOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:14:20 -0400
Date: Thu, 19 Mar 2009 13:13:07 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>,
       Dave Airlie <airlied@gmail.com>, David Airlie <airlied@linux.ie>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
	changes
Message-ID: <20090319201307.GC17094@kroah.com>
References: <20090319040809.GA29249@kroah.com> <21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com> <49C21B0B.4060809@shipmail.org> <20090319103903.43dd1ab3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319103903.43dd1ab3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 10:39:03AM +0000, Alan Cox wrote:
> > The non-existence of an open-source 3D implementation doesn't really 
> > alter that situation.
> 
> I think it does to an extent

With an opensource 2d solution it does?

> > However, if there's a policy issue about adding Linux kernel support for 
> > closed-source user-space drivers, I think it helps to be explicit about 
> > that.
> 
> Actually its a lawyer question not just policy. If the two parts being put
> together are tightly dependant on each other and in fact form a single
> work which it seems could reasonably be the case in this situation then
> if one half is GPL the other must also be so.

I'm not going to disagree with that, which would force the 3d portions
open.  At the moment I'm more worried about just getting 2d to work at
all.

I was going to wait for the "rewrite" to worry about 3d stuff, as it
will be done properly that way.

thanks,

greg k-h
