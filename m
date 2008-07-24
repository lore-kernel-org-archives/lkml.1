Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYGXWVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYGXWVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 18:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYGXWUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 18:20:53 -0400
Received: from server.drzeus.cx ([85.8.24.28]:39871 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750930AbYGXWUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 18:20:52 -0400
Date: Fri, 25 Jul 2008 00:20:46 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bad dereference in sched_mc_power_savings_store()
Message-ID: <20080725002046.083cde40@mjolnir.drzeus.cx>
In-Reply-To: <20080724202634.GH20882@one.firstfloor.org>
References: <20080724120217.163a03f3@mjolnir.drzeus.cx>
	<20080724202634.GH20882@one.firstfloor.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-11530-1216938050-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-11530-1216938050-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Jul 2008 22:26:34 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Thu, Jul 24, 2008 at 12:02:17PM +0200, Pierre Ossman wrote:
> > I get the following with yesterdays kernel:
>=20
> This patch should fix it.
>=20

Indeed it did. Thanks.

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-11530-1216938050-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiJAEAACgkQ7b8eESbyJLi6MwCgjA0WkJyA+wsXoBQaq8nwxC6N
688AnRdUpv4wSDp4LMZ+8UEVQxe9Iw5A
=KXsJ
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-11530-1216938050-0001-2--
