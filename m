Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbZJaPfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbZJaPfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 11:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757849AbZJaPfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 11:35:45 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:45054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848AbZJaPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 11:35:44 -0400
Subject: Re: OOPS in cfg80211_conn_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0910310936110.5317@parag-laptop>
References: <f7848160910291617q2b168089l5ce489d2f47ebe96@mail.gmail.com>
	 <1256885343.3555.0.camel@johannes.local>
	 <alpine.DEB.2.00.0910300652350.2223@parag-laptop>
	 <1256903425.3555.47.camel@johannes.local>
	 <f7848160910301622t2cf43b5bo5ffeda03ec2cdbfe@mail.gmail.com>
	 <1256970899.3555.86.camel@johannes.local>
	 <alpine.DEB.2.00.0910310936110.5317@parag-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hQCfJLGD+HJagSNQzC1h"
Date: Sat, 31 Oct 2009 16:11:24 +0100
Message-ID: <1257001884.3555.134.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hQCfJLGD+HJagSNQzC1h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 09:37 -0400, Parag Warudkar wrote:
>=20
> On Sat, 31 Oct 2009, Johannes Berg wrote:
> >=20
> > iw event -t -f > /tmp/log
>=20
> Here it goes - this is while trying couple times to reproduce the issue.

Ok, I think this looks fine and we don't need to do anything else. In
fact, I think the behaviour we have there now in the no-bssid case is
like the behaviour we had previously.

johannes

--=-hQCfJLGD+HJagSNQzC1h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7FOCAAoJEODzc/N7+Qma7wwP/3PXztZzuAXOQbk9fFPr8rVV
WVcFZn6W4Ts/+NpBmBAWCxKoSSL2jc0axnc3pjgrC+LZB8ppjL15djU4pwq041TC
SuTMhuBWRI3onGkSDfLRKUI176NSX8eWVtm4DkA439NdPU3xiYPcsq6w9YBULBCB
5VdU2mHUGvrBZESr5P5opL7LFWF1tDBD6dyPhn2a0k2rFb4Iit4TyQPxU4irzR4E
QiOQw4MeqHU8CSZZtlN7K3cBOLnnt6JXIh+qqh4YZfJp0R9kzNR1tY85Dehf27gl
EjGXkIlB1BlxjyglxauELHz15VxutWdHkiSYzHLPNt5r/oBI3PYUlUuDRhZrDK6l
rieGkbmRWYa64Rc0Bz4vObxLBbWPdtgqAPScxsc1iZU03ygHJchyD/5q3YBDPMos
pKvm6nNPL/i3rDVOP1AVtZ7cIpVzccDFgKzpWTjhG/MXSmaAcPZAh6eDBR6LyTU9
bxUu+JjQ9nOwjXAPtOUAclyeWDQe/HjfK0ssn3cg7loeg1ramXNOVFcPWRd3do6a
LuePPbDd/eFi9RRm34Eql20tvmkDg/QKUnc4e5P1EERAi9VmHKhaQFQtRvAn59QS
UczqdXem4xQ88V5krMzP/mgWIlO1V6ShtRdT1xueLBimUUgN1nqzVvmaFwkSyMpa
0+DbkrUfiOHpMwER4JAp
=STS/
-----END PGP SIGNATURE-----

--=-hQCfJLGD+HJagSNQzC1h--

