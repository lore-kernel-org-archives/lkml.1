Return-Path: <linux-kernel-owner+w=401wt.eu-S2992742AbXDDI0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992742AbXDDI0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992743AbXDDI0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:26:25 -0400
Received: from cel.leonerd.org.uk ([62.49.94.186]:2118 "EHLO cel.leo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992742AbXDDI0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:26:12 -0400
Date: Wed, 4 Apr 2007 09:26:09 +0100
From: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Martin Mares <mj@ucw.cz>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
Message-ID: <20070404082609.GP26707@cel.leo>
References: <46110F88.5040905@gmail.com> <mj+md-20070403.114037.27180.nikam@ucw.cz> <20070403145151.GN26707@cel.leo> <mj+md-20070403.153720.5293.nikam@ucw.cz> <1175665364.4519.10.camel@daplas> <Pine.LNX.4.61.0704041011520.10155@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXr400anF0jyguTS"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704041011520.10155@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--BXr400anF0jyguTS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2007 at 10:12:06AM +0200, Jan Engelhardt wrote:
>=20
> On Apr 4 2007 13:42, Antonino A. Daplas wrote:
> >Please note that I have dropped this patch in favor of this one:
> >
> >http://lkml.org/lkml/2007/4/2/422
>=20
> ^^ Which is ok by me.

I agree - Does The Right Thing as far as I'm concerned.

--=20
Paul "LeoNerd" Evans

leonerd@leonerd.org.uk
ICQ# 4135350       |  Registered Linux# 179460
http://www.leonerd.org.uk/

--BXr400anF0jyguTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGE2Eh7eTlovtaLtYRAhEuAKCtHyt77zFh8xQntb0+j7tRd3Z7XQCeOszA
CL02xmYbQwq1Anpynf2sjCc=
=0hgH
-----END PGP SIGNATURE-----

--BXr400anF0jyguTS--
