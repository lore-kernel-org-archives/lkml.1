Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246Ab0ATJxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0ATJxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021Ab0ATJwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:52:50 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:33956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0ATJws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:52:48 -0500
Subject: Re: [ipw3945-devel] hang on 2.6.33-rc4
From: Johannes Berg <johannes@sipsolutions.net>
To: Norbert Preining <preining@logic.at>
Cc: reinette chatre <reinette.chatre@intel.com>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100120003603.GB21011@gamma.logic.tuwien.ac.at>
References: <20100115152215.GC2541@gamma.logic.tuwien.ac.at>
	 <1263576588.2751.455.camel@rc-desk>
	 <20100119054715.GA10780@gamma.logic.tuwien.ac.at>
	 <1263920481.4838.32.camel@rchatre-DESK>
	 <1263923990.28066.3.camel@johannes.local>
	 <20100120003603.GB21011@gamma.logic.tuwien.ac.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eqIBdHvPFp3jE6q8e+xu"
Date: Wed, 20 Jan 2010 10:52:40 +0100
Message-ID: <1263981160.9171.5.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eqIBdHvPFp3jE6q8e+xu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-20 at 01:36 +0100, Norbert Preining wrote:
> On Di, 19 Jan 2010, Johannes Berg wrote:
> > Sorry, no, seems weird. The trace is not very useful unfortunately,
> is
> > this with CONFIG_FRAME_POINTER?
>=20
> # CONFIG_FRAME_POINTER is not set
>=20
> Do you need it?

The stacktrace would be a lot more useful with it set, yes. Other than
that, I don't know. If there's a way to make your display resolution
higher that might be useful so more info fits on the screen, or maybe
trimming the stack trace depth (though I don't know if that's possible,
I do know it is on powerpc because I added it there but not sure on x86)

All assuming you can reproduce this issue, of course.

johannes

--=-eqIBdHvPFp3jE6q8e+xu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLVtJjAAoJEODzc/N7+Qma3IoQAJ5n9QiiXOrOlL2OAdpNH0q1
cA1tcyp8mDi4xDXFySdeCmt5o6Eee7gUbp8UygOoDESW2doRZuLmTSRzAdbtzD/X
7ASZxiqGh/DLXVoCXr6gkBzPBEzVn6lDhPaxH9kSZ9EQT+I52dJyk6p/uBSer+Q1
0fFLZUrJI0ruiCa33WblElwuAbAYi6mb3uS7Re134cTNpTyhnmSvt2xIhRwPnWo4
0O3f8pqwsKg/3QNiuZLfeuiw6ECGG+OzUAnJc/htrzSXVrz5qZ38ZPmRJ15Fptle
OYhP0h/4ozPThwN5hU1wnHle0T2C/KI7/97L8JGxhLS5SLAB8ZBdoaoWU27oEMGc
fANC6/PzPnEfl0lDwOmKi0xgRnZI5zI8YTk4P7Zxhcaek19fwJ7X5HKo//pNSFqW
2JAvPZUnRZXN8+6MwqGjTLZH5X4XacsytFYmuW265MY318OFCnrqp0PzmSglSMxF
A5hod1mHOFDWYMrc9BZmqAZ8SQD6ZR50odHpmCzanVI0fz/sQRsCspaY9CiraUDY
OGvEPuygpvVYiTJo7nNI1FrMhEKoBN+K2jvvZRedfIoIFQG2peRHLQ8MvDahqmu2
rhA037sw2UHl4/N2Mmmy26bJutXvwKXFUfEVKQN/51jBKekDNi4brrPw4FIi9v16
d5MbD+7wwqRXNF9HE6OJ
=KPXt
-----END PGP SIGNATURE-----

--=-eqIBdHvPFp3jE6q8e+xu--

