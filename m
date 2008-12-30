Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYL3XRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYL3XRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 18:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYL3XRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 18:17:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56599 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbYL3XRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 18:17:23 -0500
Date: Wed, 31 Dec 2008 10:17:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-next@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: linux-next: origin tree build failure
Message-Id: <20081231101717.0ef30e15.sfr@canb.auug.org.au>
In-Reply-To: <adahc4ls262.fsf@cisco.com>
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
	<adavdt2ru39.fsf@cisco.com>
	<20081230193048.db7ee462.sfr@canb.auug.org.au>
	<adaljtxsma7.fsf@cisco.com>
	<20081231024654.a73f20df.sfr@canb.auug.org.au>
	<20081231095228.b21cffe0.sfr@canb.auug.org.au>
	<adahc4ls262.fsf@cisco.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__31_Dec_2008_10_17_17_+1100_YK=2CfQti+BOU60F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Dec_2008_10_17_17_+1100_YK=2CfQti+BOU60F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roland,

On Tue, 30 Dec 2008 14:56:05 -0800 Roland Dreier <rdreier@cisco.com> wrote:
>
>  > So instead of the revert, I will cherry-pick your fix commit just after
>  > Linus' tree today on the assumption that you will send it to him ASAP.
>=20
> Yes, I will batch up a few other things and send a pull request today.

Excellent!

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__31_Dec_2008_10_17_17_+1100_YK=2CfQti+BOU60F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklaq/0ACgkQjjKRsyhoI8z4DQCeNbpBtdRZty48CAeF1ojLJ4Xq
IAsAnRBvrIaqk8q2vHxbh2W7gicUi5dE
=uc+K
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Dec_2008_10_17_17_+1100_YK=2CfQti+BOU60F--
