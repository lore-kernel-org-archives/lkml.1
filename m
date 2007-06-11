Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbXFKM60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbXFKM60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 08:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXFKM6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 08:58:15 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:51978 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbXFKM6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 08:58:14 -0400
Date: Mon, 11 Jun 2007 14:59:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org, ak@suse.de
Subject: Re: [patch 4/9] lguest: the asm offsets
Message-ID: <20070611125903.GA3933@uranus.ravnborg.org>
References: <200705090951.l499pa6G020397@shell0.pdx.osdl.net> <20070509204613.GA10336@uranus.ravnborg.org> <1178755780.7286.175.camel@localhost.localdomain> <E1HxjKu-0004G6-7d@flower>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HxjKu-0004G6-7d@flower>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 02:49:32PM +0200, Oleg Verych wrote:
> * Date: Thu, 10 May 2007 10:09:39 +1000
> >
> > On Wed, 2007-05-09 at 22:46 +0200, Sam Ravnborg wrote:
> >> On Wed, May 09, 2007 at 02:51:36AM -0700, akpm@linux-foundation.org wrote:
> >> > From: Rusty Russell <rusty@rustcorp.com.au>
> >> > 
> >> > This is the structure offsets required by lg.ko's switcher.S.
> >> > 
> >> > Unfortunately we don't have infrastructure for private asm-offsets
> >> > creation.
> >> Someone maybe it was Oleg? did an OK job to abstract out asm-offset
> >> generation. I asked to have it rebased but never heard anything back.
> >> 
> >> I would like to get this generic approach in and then let lguest use it.
> >> But I do not see this as a reason to hold back inclusion in -linus.
> >
> > Hi Sam,
> >
> > 	Yeah, I never heard back either.  And I'm reluctant to try to fix it
> > myself: I've never managed to patch the build system without causing you
> > to rewrite it better 8)
> 
> If it's still open, i can try, after getting back from RL and 28k LKML
> backlog ;)

Hi Olg.

Please do so.
Thanks,
	Sam
