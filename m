Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbYCBXgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbYCBXgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 18:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYCBXgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 18:36:03 -0500
Received: from mail.gmx.net ([213.165.64.20]:36045 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752362AbYCBXgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 18:36:01 -0500
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX18WkjBqitYWajH1EFiXLfE+asbI9EudyV5GvP4Uzb
	3L+YjcDpHfn2DF
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
From: Mirco Tischler <mt-ml@gmx.de>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>,
       tglx@linutronix.de, mingo@redhat.com
In-Reply-To: <47CB10AD.3000701@free.fr>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	 <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com>
	 <47C0DB7D.70407@linux.intel.com> <47C2ED51.4000105@googlemail.com>
	 <47C344E5.5050205@linux.intel.com>
	 <20080302155348.GA74305@gandalf.sssup.it>  <47CB10AD.3000701@free.fr>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GhEFVUd7wo5w7MlrJLCj"
Date: Mon, 03 Mar 2008 00:35:57 +0100
Message-Id: <1204500957.10729.2.camel@mtlp>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GhEFVUd7wo5w7MlrJLCj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On So, 2008-03-02 at 21:40 +0100, Laurent Riffard wrote:
> Tested-by: Laurent Riffard <laurent.riffard@free.fr>
>=20
> With this patch, the WARNING at arch/x86/mm/ioremap.c does not occur anym=
ore.
>=20
> thanks
> ~~
> laurent

Yes, the patch does help for me too.

Thanks=20

Mirco

--=-GhEFVUd7wo5w7MlrJLCj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHyzndz+diZ7c2xfgRAjhHAKCEWLWhFmPCdvSGdBKIJ6Wa8S9xfgCeJYmx
wkWA7qnnwDwv8ZdRGiqo1x8=
=Az2X
-----END PGP SIGNATURE-----

--=-GhEFVUd7wo5w7MlrJLCj--

