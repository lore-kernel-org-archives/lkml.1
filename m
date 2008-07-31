Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbYGaPuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbYGaPuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYGaPuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:50:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36281 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbYGaPuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:50:13 -0400
Date: Thu, 31 Jul 2008 11:50:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jonathan Corbet <corbet@lwn.net>
cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org, greg@kroah.com,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH stable] ftrace document crucial update
In-Reply-To: <20080731093039.4afcb734@bike.lwn.net>
Message-ID: <alpine.DEB.1.10.0807311145070.31930@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0807302256180.21982@gandalf.stny.rr.com> <20080731093039.4afcb734@bike.lwn.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 31 Jul 2008, Jonathan Corbet wrote:

> On Wed, 30 Jul 2008 23:05:02 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Never mind that ftrace itself doesn't exist is 2.6.26.

s/is/in/ :-(

> 
> I just figured you were trying to raise the bar by showing that it's
> possible to get the documentation in before the code...

I'd be impressed if this happens again. ;-)

> 
> >  Copyright 2008 Red Hat Inc.
> > -Author: Steven Rostedt <srostedt@redhat.com>
> > +   Author:   Steven Rostedt <srostedt@redhat.com>
> > +  License:   The GNU Free Documentation License, Version 1.2
> 
> Is FDL appropriate for stuff shipped with the kernel?  I would suspect
> it would at least need a GPL-compatible dual-license option.

Yeah, Christoph Hellwig brought this up too. I said that I would dual 
license it (whatever that means with this) but I wanted to ask a lawyer 
first.

The question is, is the FDL really incompatible with the GPL if what is 
protected by the FDL does not get compiled and shipped as a binary?
Hence, I need to bring this up with a lawyer. And if it is indeed 
incompatible, then I will be sending out a dual license patch.

-- Steve

