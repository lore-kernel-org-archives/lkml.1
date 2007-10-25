Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbXJYCG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbXJYCG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbXJYCGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:06:17 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:56824
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbXJYCGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:06:16 -0400
Date: Wed, 24 Oct 2007 19:11:45 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ray Lee <ray-lk@madrabbit.org>, Chris Wright <chrisw@sous-sol.org>,
       Casey Schaufler <casey@schaufler-ca.com>, Adrian Bunk <bunk@kernel.org>,
       Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <20071025024131.6082e4a8@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0710241905160.21140@asgard.lang.hm>
References: <20071024223124.GI30533@stusta.de> <446110.89443.qm@web36608.mail.mud.yahoo.com>
 <20071025002356.GB3660@sequoia.sous-sol.org>
 <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
 <20071025024131.6082e4a8@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Alan Cox wrote:

>> The idea that poor security is worse than no security is fallacious,
>> and not backed up by common experience.
>
> There is a ton of evidence both in computing and outside of it which
> shows that poor security can be very much worse than no security at all.
> In particular stuff which makes users think they are secure but is
> worthless is very dangerous indeed.

there is also pleanty of evidence that you don't have to be perfect to be 
good enough.

in addition security is useually traded off for something else 
(useability, administrative effort, money, etc) and depending on what's 
being protected the cost that's appropriate is going to be different.

> When you know that security is limited you act appropriately, when you
> believe security is good but it is not you take inappropriate risks and
> get badly burned.

This is very true, but the solution isn't to try and eliminate everything 
other then perfect security, it's to properly document the limitations of 
various options and educate people about them.

David Lang
