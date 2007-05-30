Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXE3LlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXE3LlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXE3Lky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:40:54 -0400
Received: from redstar.dorchain.net ([212.88.133.153]:36672 "EHLO
	Redstar.dorchain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbXE3Lkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:40:52 -0400
X-DKIM: Sendmail DKIM Filter v0.6.1 Redstar.dorchain.net l4UBeDRN016857
Date: Wed, 30 May 2007 13:40:13 +0200
From: Joerg Dorchain <joerg@dorchain.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joerg Dorchain <joerg@dorchain.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 1/2] m68k: runtime patching infrastructure
Message-ID: <20070530114013.GE4617@Redstar.dorchain.net>
References: <20070528191630.377693320@mail.of.borg> <20070528191715.352919509@mail.of.borg> <20070529173818.fd94ae81.akpm@linux-foundation.org> <465D1020.3030605@cosmosbay.com> <Pine.LNX.4.64.0705300903030.31930@anakin> <20070530082035.GA8200@Redstar.dorchain.net> <Pine.LNX.4.64.0705301318560.6389@anakin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705301318560.6389@anakin>
X-message-flag: Formating hard disk. please wait...   10%...  20%...
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--fXStkuK2IQBfcDe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 30, 2007 at 01:19:45PM +0200, Geert Uytterhoeven wrote:
>=20
> > Actually, this is the only way to define circular referencing
> > structures.
>=20
> No, you have forward declarations for that. These are missing here.

I am no gcc expert, but might this be considred an implicit declaration?
IIRC the compiler warns if later the type does noch match. Does it keep
quiet when it matches?

Bye,

Joerg


--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGXWKdjY4+4PdzvOARAsU5AJ0b3Y+uY22Y9djlJtvO8hbkDjnIRQCcCvz8
LT1fj7EE9+cCbWXSwKEFZAk=
=8sWV
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--
