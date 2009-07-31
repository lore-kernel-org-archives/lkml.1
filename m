Return-Path: <linux-kernel-owner+w=401wt.eu-S1751574AbZGaHvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbZGaHvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 03:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbZGaHvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 03:51:23 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:37910 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZGaHvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 03:51:22 -0400
Date: Fri, 31 Jul 2009 09:51:19 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux@arm.linux.org.uk, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] Add support for LZO-compressed kernels on x86
Message-ID: <20090731075119.GB7139@pc-ras4041.res.insa>
References: <1248271279-9920-1-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-2-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-3-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-4-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-5-git-send-email-albin.tonnerre@free-electrons.com> <4A70AA64.4020301@zytor.com> <20090729210257.GA22975@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <20090729210257.GA22975@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2009 at 11:02:58PM +0200, Sam Ravnborg wrote :
> On Wed, Jul 29, 2009 at 01:00:36PM -0700, H. Peter Anvin wrote:
> > On 07/22/2009 07:01 AM, Albin Tonnerre wrote:
> > > This is the third and last part of the patch, which contains the
> > > necessary changes to the x86 Kconfig and boot/compressed to allow the
> > > use of this new compression method
> > >=20
> > > Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
> >=20
> > Acked-by: H. Peter Anvin <hpa@zytor.com>
> >=20
> > Since the patchset otherwise isn't really x86-related it probably makes
> > more sense to pass this through the kbuild tree, or perhaps via akpm,
> > rather than -tip?
>=20
> I can take it via kbuild if I get a fewsh patch-set with proper
> ack's added.
> I've long lost the original patch-set.

Only the x86-specific part of the patch has been acked so far, and it relie=
s on
3 other patches which have not been acked. If there's anything I can do to =
get
feedback on the remaining patches, please let me know.

Regards,
--=20
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKcqJ3AAoJEBEG8gBbtuSl0MkQAKfyyTMCzxLUATsEgH7c+UvZ
fpAvxeRDkGShu3+jzoTEHDgFf4AU0SuTtKydUcqwx44uIycznPcEjDqPku8Iv6Pa
uNdJ+NDajuqvUPFY+k1/pXAxqneHGSVhBe7GKHtYVbo45EaAmUMswIBQl31Bd+3y
m6HjKcOYx/wKA8DveLFnkawJpddD1d8yAjOr5qAnwSR6BWGcN69UljLAQJZuDxPL
YbWSra5gp70o8TDrd81/XC1MZ2Vf7ER101KaoMJGvIviDFp0/eud+Ihb7o63C9n+
STwwRP9fk1Re6snpaPs3cxpWmxaZOyL3bUX4Ieeag0QPYm1huLfubfg4mgq/Bnwg
p9mFFPRc+A8HmaSu3cA86e8Ec0BAAtdEnM5fXp4Fyp7psoytoHNcddIn7JSzqzN8
QUY6aO68Q+brTTPKV0TEfH43ns8VMTQiHTG7uIwHcOBZGjHkmn4jaERqtMdhUsfd
cqX9TMPpySBQpir2TOYwko7ByqDbqFXmrLh//h6vTwf1tqO9O6jrQ3dSDritYQEc
NGbsZC4cERF/+Z2lPdCx9z730PoL/YdKTdj4K3sk3CJCuBl19I+JMuP/A/Yf0XPR
3GGApy2GrWDAaOnmv1Ok36VYWJNhKh6zNHKOKj+H+05KIBCzvK4eeErwVTdK24Iu
3Vn7r0unOMd8x9yQw7so
=riEt
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
