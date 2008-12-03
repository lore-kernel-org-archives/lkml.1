Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYLCHjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYLCHjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYLCHjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:39:01 -0500
Received: from server.drzeus.cx ([85.8.24.28]:49131 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751251AbYLCHjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:39:00 -0500
Date: Wed, 3 Dec 2008 08:38:50 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Philip Langdale <philipl@overt.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       Frank Seidel <fseidel@suse.de>,
       Mathias Weyland <weyland@library.ethz.ch>
Subject: Re: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers 
 (resend)
Message-ID: <20081203083850.58e968a2@mjolnir.drzeus.cx>
In-Reply-To: <4935FEDD.3080807@overt.org>
References: <60069.67.164.5.76.1228094870.squirrel@overt.org>
	<20081202181043.8173d657.akpm@linux-foundation.org>
	<4935FEDD.3080807@overt.org>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-31252-1228289937-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-31252-1228289937-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Dec 2008 19:37:01 -0800
Philip Langdale <philipl@overt.org> wrote:

>=20
> Indeed. Pierre, seems like the patch didn't git-apply properly. It's this=
 way in your
> tree too. Did you apply the previous garbled version?
>=20

Odd.

Anyway, I've queued up the fixed versions instead. Should be hitting
next in a day or two.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-31252-1228289937-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkk2N48ACgkQ7b8eESbyJLgD2QCfVfw62+T81Efru+ccJ3lzkwTl
dlAAn0omQnPxqCx1dwb7Vge0+nxWM/jB
=7Nwj
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-31252-1228289937-0001-2--
