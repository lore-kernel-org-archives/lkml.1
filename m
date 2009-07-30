Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZG3RLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZG3RLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZG3RLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:11:47 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZG3RLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:11:46 -0400
Subject: Re: [wireless] rt2870sta BUGs on shutdown,
 2.6.30.2->git.today+git.wireless.today
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Luis Correia <luis.f.correia@gmail.com>, Mike Galbraith <efault@gmx.de>,
       linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200907301852.28172.IvDoorn@gmail.com>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <efe7343f0907300306o44d0e718p2880b7406a38fc6a@mail.gmail.com>
	 <200907301517.57811.bzolnier@gmail.com>
	 <200907301852.28172.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KVNGf1KqKc/ebASAh6eJ"
Date: Thu, 30 Jul 2009 19:11:02 +0200
Message-Id: <1248973862.22552.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.4 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KVNGf1KqKc/ebASAh6eJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 18:52 +0200, Ivo van Doorn wrote:

> [some text expressing his frustration]

This is exactly why I was against staging all the time. Now suddenly
"The Crap" seems like a viable alternative. WAKE UP PEOPLE. The code is
not useful. Just look at the code that Mike pasted into his email. That
alone should be enough to send cold shivers down your spine!

What staging has achieved here is giving the crap vendor code a
blessing, receiving it welcomingly and forgivingly instead of saying
"well screw you, go ahead and ship this to your users but don't ever say
you support Linux well" ... now even some hackers and just just "dumb
users" think that the crap in staging could possibly at some point
become useful code!

It won't. EVER. No matter _how_ much you clean it up, it will NEVER fit
into the code scheme that everything else wireless has adopted.

And, Bartlomiej, don't give me the straw-man argument of user support,
if all you cared about were users you could well have _distros_ ship the
crap. They don't want to, of course, support this, for good reason! As
long as the vendors don't wake up, and some people see The Crap as a
viable alternative, good hardware support will never become a reality.

Look what you've done, really! You've frustrated the only person (Ivo)
who cares about giving these devices _proper_ support to a point where
he's no longer really interested in it because he's always measured
against The Crap right away. And that's perfectly understandable!
Effectively, you're saying that while he may have done good work, you
don't care about it because it's not perfect. Mike at least was willing
to try rt2x00 and work with it.

And now you're coming out of the woods and claiming that The Crap
works?! When the thread started with how it crashed? Get real.

In the end, while the letters you typed into your email claim to say the
opposite, the message of your email is that nobody should care about
rt2x00 and that the vendor driver should remain the status quo. Well, in
that case, get lost, crawl into the staging list and at least don't
bother us with The Crap.

Such attitude is part of the problem, the other big part is that vendors
can now claim their hardware "has mainline Linux support (in the staging
area)" and nobody will be the wiser.

So how about you help work on it, or think about a solution instead?

johannes


--=-KVNGf1KqKc/ebASAh6eJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcdQjAAoJEODzc/N7+QmaoQsQAIdwgcaHQ18Tiw1g7TFuCBXE
b4O57ZRkFZszl5+lq97aizx3quZy+VBeUAahqxI9M4DkFCfxF0WzCQHm6mZL/6l+
WOFtZlT1cUqqfX9mU3ifezbtrMEUuOOsbtQZmSIDFnQlIyhs5bEaKhZvdmcTb6vv
ltRTOAXb0Pcpgb7sa0axEZ8WesfZ3m3Z/9WofS5y2+szzjeD02HAfukcXIhxhR8V
l02daslPLMddNlHWbJos5cSShjhJ/xjpjyikDXvVfgewPauwT1TvAa13xUaqF0AF
9XuNB0suGGGNnqFHSBGpoH0cXJRw4kiWWmEIxScIFq11heRrQccYLYWquIUjvYhO
S0b8W/pP4X3ZR5cvKV06G3pJaknRyk7kvLn39KEJQjccH5Y8O/IjgA7/OaAwX9iN
o7B19dXh4JvBvlShKWL230VQRZEz8Cvh+D7enQ9wCMFV/eAzDghf16z2+Alhqoe1
o6Z/wv7Ap0Udi4CRBs3RYYVwqXqe5Pwe8CaVez1PcyqQipwDoAu1thELU8/obXl5
/qyAGXh/rlw5OGrwgWRLqssaM5Ly4sYPzMjo9hZ9VD1hTw0MjHQimjzdqkMV/WMs
kIa7eNu82RGo6FW+ETBRgRNLsKfR2YTcriq+0WCVbadX0x73gGSYH6IM5m4VnpKm
1C4X62vGdCrXC6I9GzbX
=+ARg
-----END PGP SIGNATURE-----

--=-KVNGf1KqKc/ebASAh6eJ--

