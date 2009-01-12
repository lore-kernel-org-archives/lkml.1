Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZALPZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZALPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZALPZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:25:15 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:60800 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZALPZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:25:14 -0500
Date: Mon, 12 Jan 2009 16:18:57 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "???? ??" <mauriceliu27@hotmail.com>, linux-kernel@vger.kernel.org,
       nick piggin <nickpiggin@yahoo.com.au>
Subject: Re: [BUG] AS-ioscheduler: kernel panic at as_exit_queue
Message-ID: <20090112161857.06d237a7@mjolnir.drzeus.cx>
In-Reply-To: <20090109080517.GI32491@kernel.dk>
References: <COL120-W718F2E0FBF40D8870415BFDEDC0@phx.gbl>
	<20090109080517.GI32491@kernel.dk>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-6686-1231773541-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-6686-1231773541-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 9 Jan 2009 09:05:17 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

>=20
> Please try a newer version, I _think_ this was fixed in sd. CC'ing
> Pierre, just in case.
>=20

When it comes to block layer interactions, and hot removal in
particular, I'm still sticking my head in the sand and wishing the
problems away.

Fully understanding that creation of yours has so far proved to require
way more time than I've been able to put into it. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-6686-1231773541-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklrX2UACgkQ7b8eESbyJLj/FACgreKUFxmZvursJP19mhvJ+91h
gcsAn0jCBuYtqCWQyKGxi2yDCIr2z2IQ
=U3f+
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-6686-1231773541-0001-2--
