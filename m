Return-Path: <linux-kernel-owner+w=401wt.eu-S932872AbZLFQUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbZLFQUI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 11:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932745AbZLFQUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 11:20:07 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:58749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbZLFQUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 11:20:06 -0500
Subject: Re: [tip:tracing/urgent] tracing: Fix event format export
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20091203145504.GA959@elte.hu>
References: <20091113224009.GB23942@elte.hu>
	 <tip-811cb50baf63461ce0bdb234927046131fc7fa8b@git.kernel.org>
	 <1259851297.12870.134.camel@gandalf.stny.rr.com>
	 <20091203145504.GA959@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+lCmXfhA7XxuLRqQwpt2"
Date: Sun, 06 Dec 2009 17:19:41 +0100
Message-ID: <1260116381.3461.16.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+lCmXfhA7XxuLRqQwpt2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-03 at 15:55 +0100, Ingo Molnar wrote:

> > Any reason that this did not make it into Mainline? 2.6.32 is out, and=20
> > Johannes Berg was depending on this for his users.
>=20
> Yeah, it narrowly missed the last -rc (-rc8), and we only push=20
> post-final-rc fixes for serious show-stopper regressions.

You have an interesting definition of "narrowly missed":

$ git show v2.6.32-rc8
...
Date:   Thu Nov 19 14:32:50 2009 -0800
...
$ git show --pretty=3Dfuller 811cb50baf63461ce0bdb234927046131fc7fa8b
...
CommitDate: Fri Nov 13 22:20:34 2009 -0500

And Steven's pull request for this very simple fix was from the 14th.
That's 5 days until -rc8.

So maybe I have a personality problem, but suck it up -- you're wrong
this time.

johannes

--=-+lCmXfhA7XxuLRqQwpt2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLG9maAAoJEODzc/N7+QmaK8oQAMl4krMRphc22T3pXmnssM8t
gTkr3QSfF7asz+lWrqrMTlek8pwKJvT6rnuF54jAED9G0PRvoP/1HbF1tQHbd6zz
oJS893HvcHaUpP3I2KrffOycrV/PJmiA7RxQNJcTkCRWEYNvhMLy954tkl79QR9F
jCNejjNyUVlAacgf+r08IEzniWVDuPk1ZiDPnpa9eC9HKeHUkRlzca+21Xdc9f0q
l5al8YdvTWfVQKWPO98KBZw1hu+AQHvvBWg9CS+XKUDVdxYLrIp3DEwIhLLnTnYH
tS0TKohf5OHylx/euHgPjOsSMrg9lbyQokdXVV58nRIcR2m5aRrkBW26oXpQGkPW
Pqjjm4YoFd6/rIs81NbCnSXbC5aRM2zXZrL/6s9xMM0AX82SgXLNpA8/yDl8Cx0M
hWUJnVpkm4RlsmhCw/epReWtx6h3fO6Glj5gedVy2iF6OC9FE2cohoxTC/S+aeFR
/sQhEDCwc+a4YBYjsNN38WN3R2M5UN/6sWoIXH/paYrZhEMGW6gwtZhh7QZQra9d
CcvYPHCR3m6edIg+t/GIEGyhDXUNGV3T+VfSqtbU+xcltGgVYjzfMRZzMIfPoH8b
KHMQ95SZKwzIJyjJAtf9DILhwT1d9AiE6aKHi/Rh0NAIxBnjsGl9fUq86M1QbVJU
kvoja/0AnjZNwOcPEenc
=010B
-----END PGP SIGNATURE-----

--=-+lCmXfhA7XxuLRqQwpt2--

