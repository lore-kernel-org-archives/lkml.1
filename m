Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYHMMMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYHMMMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 08:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYHMMMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 08:12:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2305 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751324AbYHMMMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:12:14 -0400
Date: Tue, 12 Aug 2008 19:56:36 +0200
From: Pavel Machek <pavel@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Peter Moulder <Peter.Moulder@infotech.monash.edu.au>,
       Andi Kleen <ak@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [RFC] typesafe callbacks?
Message-ID: <20080812175635.GA6153@ucw.cz>
References: <200808111756.21850.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808111756.21850.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>   Well, noone else voiced great enthusiasm about typesafe callbacks.  I esp.
> like them because we can use them to wean off unsigned long in timer
> callbacks without a flag day.
> 
> Should I just drop these patches, or leave them in -next for a third round?
> Rusty.

I think it is a great idea..
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
