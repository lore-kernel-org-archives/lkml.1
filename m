Return-Path: <linux-kernel-owner+w=401wt.eu-S1752252AbXFNMwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbXFNMwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXFNMwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:52:39 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:44632 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbXFNMwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:52:38 -0400
Date: Thu, 14 Jun 2007 14:52:24 +0200
From: markus reichelt <ml@mareichelt.de>
Subject: Re: /dev/loop* devices not appearing in /dev (at least since
 2.6.22-rc3*)
In-reply-to: <e85b9d30706140437s5f3622c3rc86c75a4f845e7a3@mail.gmail.com>
To: linux-kernel@vger.kernel.org
Mail-followup-to: linux-kernel@vger.kernel.org
Message-id: <20070614125224.GA4155@tatooine.rebelbase.local>
Organization: still stuck in reorganization mode
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=gBBFr7Ir9EOA20Yy
Content-disposition: inline
X-IronPort-AV: E=Sophos;i="4.16,420,1175472000";   d="scan'208";a="2175964"
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
References: <e85b9d30706140437s5f3622c3rc86c75a4f845e7a3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Matthew <jackdachef@gmail.com> wrote:

> I read that now loop devices are being created on demand, which
> obviously (still) not works

yes, someone thought this was a good idea :(


> Is there a way to trigger such creation?

does modprobe loop max_loop=3D32 work?

--=20
left blank, right bald

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGcToILMyTO8Kj/uQRAifaAJ4kG6c49e+ypSZWKDciT7xv4BilcACbBLgW
USlfiWwGTgy2J+EgqgYGVJ4=
=r7Jz
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
