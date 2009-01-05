Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbZAEFNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbZAEFNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 00:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZAEFM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 00:12:59 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:54633 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbZAEFM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 00:12:59 -0500
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.36,330,1228086000";   d="scan'208";a="95404767"
Date: Mon, 05 Jan 2009 06:12:55 +0100
From: markus reichelt <ml@mareichelt.de>
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 2015 of file
 fs/xfs/xfs_da_btree.c
Message-id: <20090105051255.GD6165@tatooine.rebelbase.local>
Mail-followup-to: LKML Mailinglist <linux-kernel@vger.kernel.org>
References: <49600DE6.2080108@shikadi.net>
 <20090104074659.GA16775@infradead.org> <49607B5B.3070707@shikadi.net>
 <20090104092349.GA26194@infradead.org>
 <20090104114425.241f6630@lxorguk.ukuu.org.uk>
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=bajzpZikUji1w+G9
Content-disposition: inline
In-reply-to: <20090104114425.241f6630@lxorguk.ukuu.org.uk>
Organization: still stuck in reorganization mode
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bajzpZikUji1w+G9
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > On Debian based systems you can add -W0 to /etc/default/hdparm
> > and it gets executed before the root filesystem is remounted
> > read-write, I'm not sure how other distributions handle it.
>=20
> Generally they avoid setting -W0 because it ruins performance and
> can be very bad for disk lifetime. The barriers code is there for a
> reason.

First time I read about a possible negative impact of disabled
write-cache to disk lifetime. Do you know of an article for further
reading?

--=20
left blank, right bald

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFJYZbXLMyTO8Kj/uQRAl7FAJ977cGNMSxH9t8o70qYzp0IBRlhcQCfXnCi
X9Gd7eFxtduH9jhZ4BHuJz8=
=xTtF
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
