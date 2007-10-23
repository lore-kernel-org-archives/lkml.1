Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbXJWC2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbXJWC2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXJWC2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:28:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067AbXJWC2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:28:44 -0400
Date: Mon, 22 Oct 2007 19:28:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] lguest: paravirt boot code
In-Reply-To: <200710221237.14542.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.0.999.0710221927131.30120@woody.linux-foundation.org>
References: <200710221237.14542.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Oct 2007, Rusty Russell wrote:
> 
> 	First attempt at git, so please pull carefully.  I've just put the
> three i386 boot changes in the repo for the moment.  If this works I'll pile 
> on the 44 lguest patches.

Well, it looked ok, but I had already merged the same patches through 
Andrew, so when I pulled, I had no differences. So I ended up unpulling, 
but not because there was anything *wrong* with your tree, just because 
the pull didn't give me anything but a slightly more complex history ;)

		Linus
