Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZFCMnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZFCMnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 08:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZFCMnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 08:43:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42064 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753332AbZFCMna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 08:43:30 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, davem@davemloft.net,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Sergey Lapin <slapin@ossfans.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1244021629-18409-2-git-send-email-dbaryshkov@gmail.com>
References: <1244021629-18409-1-git-send-email-dbaryshkov@gmail.com>
	 <1244021629-18409-2-git-send-email-dbaryshkov@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EmZRZA+LukKqUoaZJojX"
Date: Wed, 03 Jun 2009 13:43:24 +0100
Message-Id: <1244033004.21215.4.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
X-SA-Exim-Connect-IP: 192.168.4.182
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 1/6] crc-itu-t: add bit-reversed calculation
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EmZRZA+LukKqUoaZJojX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 13:33 +0400, Dmitry Eremin-Solenikov wrote:
[...]=20
> +/**
> + * crc_itu_t_bitreversed - Compute the CRC-ITU-T for the data buffer;
> + * the buffer content is assumed to be bit-reversed
[...]

This short description spills onto two lines which is invalid and breaks
the generation of docs.  Sorry to point this out after recommending the
patch to you.

I've changed the description to "crc_itu_t_bitreversed - Compute the
CRC-ITU-T for a bit-reversed data buffer" all on one line.

Ben.
=20
--=20
Ben Hutchings
Logic doesn't apply to the real world. - Marvin Minsky

--=-EmZRZA+LukKqUoaZJojX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBKJm/i79ZNCRIGYgcRAuH+AJ0R1XimrXgIoZRiTPJhce06vouOmwCfaMi/
PHrKQyUstX71t14CbcFoZB8=
=rl3w
-----END PGP SIGNATURE-----

--=-EmZRZA+LukKqUoaZJojX--
