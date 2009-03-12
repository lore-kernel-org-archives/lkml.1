Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZCLMIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZCLMIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZCLMHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:07:50 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:45481 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbZCLMHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:07:49 -0400
Date: Thu, 12 Mar 2009 13:07:46 +0100
From: Nico Schottelius <nico-linux-configs@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: announce@l.schottelius.org
Subject: Collection of working and tested kernel configurations
Message-ID: <20090312120745.GA30728@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-configs@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	announce@l.schottelius.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc7-next-20090306-ikn x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

As I'm testing many different kernel versions in the last time,
I collected all the configurations, so somebody else with an X200
or T60 can just grab a working configuration.

If you also have a long list of working configurations or want to
share your config, just update against the following git repo:

  http://git.schottelius.org/configs/linux/
  git://git.schottelius.org/configs/linux/
  http://git.schottelius.org/?p=3Dconfigs/linux;a=3Dsummary

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm4+xEACgkQuL75KpiFGIxHBQCfVyPYlZfxJf0j9VyN8SepAi/t
amEAn0vHtH/NfmhyCUtezQ9ektE0/oxQ
=0F4R
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
