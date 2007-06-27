Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbXF0QOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbXF0QOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761093AbXF0QOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:14:34 -0400
Received: from systemlinux.org ([83.151.29.59]:48900 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759831AbXF0QOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:14:33 -0400
Date: Wed, 27 Jun 2007 18:12:28 +0200
From: Andre Noll <maan@systemlinux.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: mchan@broadcom.com, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net
Subject: Re: 2.6.21.x kernel panic (tg3 and nfs related)
Message-ID: <20070627161228.GS22589@skl-net.de>
References: <20070627101608.GQ22589@skl-net.de> <4682891A.2070900@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCKkSrrNUaKEhaIQ"
Content-Disposition: inline
In-Reply-To: <4682891A.2070900@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--lCKkSrrNUaKEhaIQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:58, Chuck Ebbert wrote:
> > Screenshots of the resulting kernel panics are available at
> >=20
> > 	http://www.systemlinux.org/~maan/shots/huangho-crash-2.6.21.1.png
> > and
> > 	http://www.systemlinux.org/~maan/shots/huangho-crash-2.6.21.5.png
> >=20
>=20
> Looks the the known oops in show_mem(); patch is queued for 2.6.21.6.

I see. Thanks.

> But it is hard to tell when the screen shot doesn't show the whole
> message...

There's no way to scroll up after a kernel panic. I already changed
the video setting to use a smaller font, so if it happens again,
there will be more info visible.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--lCKkSrrNUaKEhaIQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGgoxsWto1QDEAkw8RAhRVAJ40vEvKxoMbYql5i0jKsfLmv/JEXACffmdg
gx5aNuyGe4ggds3LBp/oHvo=
=hAwp
-----END PGP SIGNATURE-----

--lCKkSrrNUaKEhaIQ--
