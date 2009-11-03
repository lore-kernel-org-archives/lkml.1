Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZKCIcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZKCIcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 03:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZKCIcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 03:32:01 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:57317 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZKCIcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 03:32:00 -0500
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20091103082201.GG3212@core.coreip.homeip.net>
References: <20091103053156.GA3212@core.coreip.homeip.net>
	 <20091102.224957.32364226.davem@davemloft.net>
	 <20091103065238.GE3212@core.coreip.homeip.net>
	 <1257232587.3420.55.camel@localhost.localdomain>
	 <1257234299.28469.25.camel@johannes.local>
	 <20091103082201.GG3212@core.coreip.homeip.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CB/G62bNgs40g0cTiXAB"
Date: Tue, 03 Nov 2009 09:31:01 +0100
Message-ID: <1257237061.28469.43.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CB/G62bNgs40g0cTiXAB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-03 at 00:22 -0800, Dmitry Torokhov wrote:

> I do not understand what the fuss is about. We are pretty far in release
> process (rc6 is about to be cut I'd expect) and we have an issue that
> for all practical purposes kills the box on resume. Yes, I want action
> to be swift in this case and (unless author or maintainer - who were
> CCed on the email - have otehr solutiuon) the offending commit to be
> reverted. If it was rc1 or rc2 or 3 I'd feel differently.

Oh, I don't disagree that swift action is good.

I just think that it's a matter of courtesy that should be independent
from the release cycle to ask the author/maintainer by default, not as a
second thought ("unless [...] have other solution"). You can always CC
Linus and ask him to revert if you don't get a response.

What's wrong with that? It doesn't actually delay the action, but it
makes the discussion much more friendly and cooperative instead of
giving the author and maintainer the feeling that their opinion only
matters as a second thought.

johannes

--=-CB/G62bNgs40g0cTiXAB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7+pBAAoJEODzc/N7+QmaleEQALrJx+RBh+PaAX6bDz6T6s0S
x1RsLBe/yeYwR0hUa/T+LSDCWdIY/W5YhPeSYSCCO4eF5WCMAq6Bj19XhjMmlADj
ucVCJPuGgHshRVGRGaCjlGdxKW+PeuKbuRcTqjiPfXQKFy51jgh00VKWYkTxjQ3x
L/nnB9qwH0ig32oVbC4Q5KmZ7I2/hUci9KE1SMIErWOBnPTq+6YzghNSQdbNz1S9
alr30zWvZzFkUfGzNlew8emyhr9If/l1jFrY9laf7GHo2ZRmHzvXgFxBnmIh1Xiz
dNxYOb2Tz5ai318EM6G0H5uqZXMc8ZXe85garcAu4RYlWCLrgF2j09+CyiPgGnmi
HPFn1yrP8nkMiiZADwh4mh7fhObc8iRgSyOkhua1DPEJ+QVCgjcgXsZ3OrhlBLoO
FDlvcYqnM3sH33CVq1CUVNZFx0WBwFdGHQ6yJT7DAQH0cHqlwE0JRcDDCOYY0e13
NgycI/UJ3DUGapKbVMmjmifa5QHUSHAHCfONLqmvyGrFnwgSJjAjPN9qk4MvMRfP
x1AXhFiTyqRN5FP9jzLa4yg/1LGdYYW8QyK2jp8pyqqXJzbSmCscfZV2zeSZgoP+
PX0NZGQC0NBCIFOvoq2FpqSvH4HdKsNZt2Dt0daAL8kwBayLpRzYEGDajGn+otCN
BL6fnpXhpxgy71pgHRj7
=GiP9
-----END PGP SIGNATURE-----

--=-CB/G62bNgs40g0cTiXAB--

