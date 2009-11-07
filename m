Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbZKGBOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbZKGBOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 20:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757755AbZKGBOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 20:14:52 -0500
Received: from kroah.org ([198.145.64.141]:40734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757742AbZKGBOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 20:14:51 -0500
Date: Fri, 6 Nov 2009 16:07:49 -0800
From: Greg KH <greg@kroah.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       Luis.Rodriguez@atheros.com
Subject: Re: [PATCH] staging/otus: trivial, fix sparse warnig.
Message-ID: <20091107000749.GA26070@kroah.com>
References: <1256861066-21954-1-git-send-email-tfransosi@gmail.com>
 <20091106224728.GA32205@kroah.com>
 <a4c8a6d00911061547x3d502de5i8a459385e1a5a9ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4c8a6d00911061547x3d502de5i8a459385e1a5a9ff@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06, 2009 at 09:47:22PM -0200, Thiago Farina wrote:
> Hi Greg,
> 
> On Fri, Nov 6, 2009 at 8:47 PM, Greg KH <greg@kroah.com> wrote:
> > The tabs somehow got converted to spaces in your patches, so they can't
> > be applied :(
> 
> I can't see spaces instead of tabs in this patch, may be you are
> talking about other patch?

Well, for some reason this patch would not apply at all, it looks like
there are no tabs in it.

> > care to rediff both of them?
> Sure, but which?

This one, and you sent another otus one, right?

thanks,

greg k-h
