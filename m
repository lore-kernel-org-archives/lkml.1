Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbZFKSuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbZFKSuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZFKSt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:49:59 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:36638 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbZFKSt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:49:58 -0400
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.42,203,1243807200";   d="scan'208";a="15105273"
Date: Thu, 11 Jun 2009 20:49:56 +0200
From: markus reichelt <ml@mareichelt.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many processes
Message-id: <20090611184955.GA7018@tatooine.rebelbase.local>
Mail-followup-to: linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=45Z9DzgjV8m4Oswq
Content-disposition: inline
In-reply-to: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
Organization: still stuck in reorganization mode
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Kernel: 2.6.30
> Dist: Debian Testing
> xfsdump: 2.2.48-1

I can reproduce this on Slackware 12.2 (2.6.30, xfsdump 2.2.48)


--=20
left blank, right bald

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFKMVHTLMyTO8Kj/uQRAnWBAJ9onVX27Ppn13HFPhV3gNDU/65zXgCdGCev
DJJc4vg1T0dVKzWzMzEaiO0=
=7baa
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
