Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbXJYSSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbXJYSSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXJYSSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:18:01 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:12399 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbXJYSR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:17:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=olZwOY/lkS4zZCbo4IrRmOhcEKGG8aalZSj4gq2AjgWSSRDIVMTFDDnz4pUCFbRz7VC+tYJZoZ2QMAvYa27AXpBk8XQmjc/9eK5+Q92dHrNOJRYy9jSeGLTqGZSgJn+QbvZpctQ0q+gSxhJhY9T0Q2MrUL3ZZIR3N2HnO9CrX+g=
Message-ID: <2c0942db0710251117k37c30b2ex5cc6d8cd8c9ea029@mail.gmail.com>
Date: Thu, 25 Oct 2007 11:17:56 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
Cc: "Chris Wright" <chrisw@sous-sol.org>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Adrian Bunk" <bunk@kernel.org>, "Simon Arlott" <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       "Giacomo Catenazzi" <cate@debian.org>
In-Reply-To: <20071025024131.6082e4a8@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024223124.GI30533@stusta.de>
	 <446110.89443.qm@web36608.mail.mud.yahoo.com>
	 <20071025002356.GB3660@sequoia.sous-sol.org>
	 <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
	 <20071025024131.6082e4a8@the-village.bc.nu>
X-Google-Sender-Auth: 1a38d060e0904a33
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > The idea that poor security is worse than no security is fallacious,
> > and not backed up by common experience.
>
> There is a ton of evidence both in computing and outside of it which
> shows that poor security can be very much worse than no security at all.

(So, I take it that you *don't* lock your bike up, as poor security is
worse than none?)

While I believe you, I'd love to see references as it doesn't match my
day-to-day experience with Win/Mac end-users over the past ten years.

> In particular stuff which makes users think they are secure but is
> worthless is very dangerous indeed.

I have no trouble believing that.

> When you know that security is limited you act appropriately, when you
> believe security is good but it is not you take inappropriate risks and
> get badly burned.

'Inappropriate risks' nowadays is surfing the web and opening up mail
attachments that claim to be movies of dancing bears. I'd argue that
users have a reasonable expectation that these are things that should
'just work,' and be safe, much as normal humans have an expectation
that their car isn't going to explode when they turn the ignition.

Perfect is the enemy of good, or words to that effect, right? My point
is that requiring perfection out of a security framework is a bar
that's going to be awfully difficult to reach (and when it supposedly
has been achieved, as in SELinux, mere mortals find it too troublesome
to run with as it's far too difficult to configure). Security can and
should be done in layers, and what one may miss, another may catch.

Ray
