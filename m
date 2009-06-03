Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbZFCU2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbZFCU2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZFCU22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:28:28 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51651 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZFCU21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:28:27 -0400
Date: Wed, 3 Jun 2009 22:28:24 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: ian@mnementh.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mmc: tmio_mmc: add bus_shift support
Message-ID: <20090603222824.2be98423@mjolnir.ossman.eu>
In-Reply-To: <74d0deb30905300446k606289cctc56efe68fdc7193d@mail.gmail.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
	<1243279681-4233-3-git-send-email-philipp.zabel@gmail.com>
	<4A2109C7.5080009@f2s.com>
	<74d0deb30905300446k606289cctc56efe68fdc7193d@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-31326-1244060907-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-31326-1244060907-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 30 May 2009 13:46:06 +0200
pHilipp Zabel <philipp.zabel@gmail.com> wrote:

> On Sat, May 30, 2009 at 12:26 PM, Ian molton <spyro@f2s.com> wrote:
> > Acked-by: Ian Molton <ian@mnementh.co.uk>
> >
> > Works fine on the e-series machines, however checkpatch has a few warni=
ngs
> > about overlength lines. I dont think they are a problem, but its not my=
 call
> > - Pierre?
>=20
> Yes, if you prefer I'll resend with those lines broken up.
>=20

Please do. And included that amended diff at the same time. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-31326-1244060907-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkom3OsACgkQ7b8eESbyJLjKNQCfYpkdnGekQkKyjrGTJMORF4Wb
wOwAn0Hg3gUBtTo+PLTMhl8ETWY77KXc
=FEaX
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-31326-1244060907-0001-2--
