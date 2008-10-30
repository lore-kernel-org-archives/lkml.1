Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYJ3JHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYJ3JHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYJ3JHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:07:00 -0400
Received: from server.drzeus.cx ([85.8.24.28]:56631 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753271AbYJ3JG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:06:59 -0400
Date: Thu, 30 Oct 2008 10:06:52 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: mmc: struct device - replace bus_id with dev_name(),
 dev_set_name()
Message-ID: <20081030100652.73730cdf@mjolnir.drzeus.cx>
In-Reply-To: <1225329600.5970.72.camel@nga.site>
References: <1225329600.5970.72.camel@nga.site>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-9819-1225357616-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-9819-1225357616-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Oct 2008 02:20:00 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: mmc: struct device - replace bus_id with dev_name(), dev_set_nam=
e()
>=20
> Cc: Pierre Ossman <drzeus@drzeus.cx>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> ---

That patch looks good to me. Are the prerequisites already in Linus'
tree so you want me to push this to him as well?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-9819-1225357616-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkJeTAACgkQ7b8eESbyJLgKGACfcifhJoN5fjqmuYYAOUkfKB1p
FqkAoIp1/Wkzze1Dw3MRXVup0A6t0uiV
=MBYf
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-9819-1225357616-0001-2--
