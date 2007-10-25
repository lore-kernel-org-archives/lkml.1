Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbXJYWmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbXJYWmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbXJYWmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:42:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690AbXJYWmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:42:17 -0400
Date: Thu, 25 Oct 2007 15:41:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       virtualization@lists.linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [git pull] lguest: paravirt boot code
In-Reply-To: <200710251519.05641.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.0.999.0710251538590.30120@woody.linux-foundation.org>
References: <200710221237.14542.rusty@rustcorp.com.au>
 <200710231603.21620.rusty@rustcorp.com.au>
 <alpine.LFD.0.999.0710230903330.30120@woody.linux-foundation.org>
 <200710251519.05641.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Oct 2007, Rusty Russell wrote:
> >
> > 	git diff -M --stat --summary
> 
> Thanks, that is much better.  I was just happy to locate git diff in the 133 
> git commands on my system; finding options 4, 8 and 22 was beyond my skill.

Hey, we give you the power. Actually realizing it all and getting used to 
it may take some time. In the meantime, you can use the pre-canned helper 
functions and just cut-and-paste from emails ;)

One of the 133 git commands is actually "git request-pull" that does this 
all for you. I always forget it, because I don't use it myself, and quite 
frankly, it's just a shell-script helper to do this all for you. But if 
you're into that kind of thing, you can actually read that shell-script 
(and others) and learn more that way ;)

		Linus
