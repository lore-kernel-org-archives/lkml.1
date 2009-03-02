Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbZCBUip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbZCBUip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZCBUib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:38:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3326 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZCBUia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:38:30 -0500
Date: Mon, 2 Mar 2009 20:38:20 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-ID: <20090302203819.GI19744@sirena.org.uk>
References: <20090301001829.GA10751@mit.edu> <20090301004618.GA12909@sirena.org.uk> <20090301025357.GC10751@mit.edu> <20090302131514.GC19744@sirena.org.uk> <49ABF825.1010501@s5r6.in-berlin.de> <20090302100158.bb83bec6.akpm@linux-foundation.org> <20090302182456.GF19744@sirena.org.uk> <20090302103437.f3109332.akpm@linux-foundation.org> <20090302191910.GG19744@sirena.org.uk> <20090302195725.GB25469@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302195725.GB25469@mit.edu>
X-Cookie: What hath Bob wrought?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 02:57:25PM -0500, Theodore Tso wrote:

> If you mean stuff like this:

>     commit a39a021fd73ce06aad8d1081ac711a36930e6cb8
>     Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
>     Date:   Wed Feb 4 21:10:58 2009 +0100
> 
>         mfd: Mark WM835x USB_SLV_500MA bit as accessible

>         The code is out of sync with the silicon.

> What I wouldn't know, looking at the message, and what I suspect
> Andrew is complaining about, is after reading the entire commit log,

No, and in fact that's a perfect example of what I'm talking about when
I say that simply writing a second paragraph for the commit logs is not
a helpful way to deal with the problem here (since it isn't the issue at
all).

As I've said on a number of occasions already in this thread I am not
trying to claim that my commit logs have always been the best or that
Andrew was complaining about nothing.  I'm perfectly well aware of the
sort of things that go into a good commit log, I read quite a lot of
them when reviewing patches myself, and do try to provide useful logs
even though I don't manage it all the time.
