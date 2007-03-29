Return-Path: <linux-kernel-owner+w=401wt.eu-S1030716AbXC2UxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030716AbXC2UxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 16:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030720AbXC2UxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 16:53:16 -0400
Received: from igw1.br.ibm.com ([32.104.18.24]:58826 "EHLO igw1.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030716AbXC2UxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 16:53:16 -0400
Subject: Re: regarding kernel preemption
From: Rodrigo Rubira Branco <rrbranco@br.ibm.com>
Reply-To: rrbranco@br.ibm.com
To: linux-kernel@vger.kernel.org
In-Reply-To: <20070329162146.GA32670@ld0162-tx32.am.freescale.net>
References: <7783925d0703290905u1e4d94f2v88d6f1736c52de81@mail.gmail.com>
	 <20070329162146.GA32670@ld0162-tx32.am.freescale.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ltKikBE9ALWGOc+yWSDL"
Organization: IBM - LTC/Brazil
Date: Thu, 29 Mar 2007 17:54:29 -0300
Message-Id: <1175201669.4599.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ltKikBE9ALWGOc+yWSDL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I recommend this link for more info:
http://www.linuxjournal.com/comment/reply/5600

Sent me a mail if you need any other explanation into this.

Cya,


Rodrigo (BSDaemon).

On Thu, 2007-03-29 at 11:21 -0500, Scott Wood wrote:
> On Thu, Mar 29, 2007 at 09:35:13PM +0530, Rick Brown wrote:
> > When we preempt_enable() / preempt_disable(), is the kernel preemption
> > enabled or disabled for ALL the processors or just the local
> > processor?
>=20
> Just the local processor.
>=20
> -Scott
> -
> To unsubscribe from this list: send the line "unsubscribe linux-newbie" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.linux-learn.org/faqs
--=20
Rodrigo Rubira Branco
Software Engineering - Advanced Linux Response Team (ALRT)
IBM Linux Technology Center (IBM/LTC)
rrbranco@br.ibm.com

GPG KeyID: 5E90CA19

--=-ltKikBE9ALWGOc+yWSDL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGDCeExJRNvl6QyhkRArLNAJ94bb24k8tqMSTR9+l4ks0dKQX6DgCdFUI+
lzgf7t3Thpo1o8uiTTk9xuU=
=M6zK
-----END PGP SIGNATURE-----

--=-ltKikBE9ALWGOc+yWSDL--

