Return-Path: <linux-kernel-owner+w=401wt.eu-S1751616AbXFVByg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbXFVByg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 21:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXFVBxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 21:53:52 -0400
Received: from paragon.brong.net ([66.232.154.163]:54434 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbXFVBxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 21:53:49 -0400
Date: Fri, 22 Jun 2007 11:33:17 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Message-ID: <20070622013317.GG30132@brong.net>
References: <MDEHLPKNGKAHNMBLJOLKEEINEMAC.davids@webmaster.com> <orvedgj3hu.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orvedgj3hu.fsf@oliva.athome.lsd.ic.unicamp.br>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 08:23:57PM -0300, Alexandre Oliva wrote:
> On Jun 21, 2007, "David Schwartz" <davids@webmaster.com> wrote:
> 
> >> > Wouldn't that defeat the entire purpose of the GPLv3? Couldn't
> >> > I take any
> >> > GPLv3 program, combine it with a few lines of Linux code, and
> >> > Tivoize the
> >> > result?
> 
> >> No.  This is not permission to relicense.  This is permission to
> >> combine.  Each author still gets to enforce the terms of her own code.
> 
> > This makes no sense. We are not talking mere aggregation here, we are
> > talking developmental convergence. If I wrote some code that was in the
> > Linux kernel, how can I enforce the terms of my code (guaranteed write to
> > Tivoize) in the derivative work that it becomes mixed with?
> 
> In just the same way you'd enforce it today: with help from a lawyer
> who understands these issues that you clearly don't understand.

Great, so for ever and ever afterwards the code would have to keep a
clear separation between the bits that are under different licences and
make sure that no re-factor ever blurred the lines between them enough
that you had trouble telling which was which.

And don't even get me started about some poor innocent end-user who just
wants to use some code from your mutant frankenstein "project" in her
pong game (or was it tetris, I lose track of what you're supposed to be
playing on your hacked TiVo while it's not allowed to connect to their
network any more) and understand what licence the final work is under.

Ouch.

Bron.
