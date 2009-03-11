Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbZCKK5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbZCKK5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZCKK50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:57:26 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:56191 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZCKK5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:57:25 -0400
Date: Wed, 11 Mar 2009 11:57:22 +0100
From: Nico Schottelius <nico-linux-ipw3945-devel@schottelius.org>
To: "Luo, Ximin" <ximin.luo@intel.com>
Cc: "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [ipw3945-devel] iwlagn: Cannot allocate memory on
	2.6.29-rc4-ikn-00001-gd5b5623
Message-ID: <20090311105722.GB5471@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-ipw3945-devel@schottelius.org>,
	"Luo, Ximin" <ximin.luo@intel.com>,
	"ipw3945-devel@lists.sourceforge.net" <ipw3945-devel@lists.sourceforge.net>,
	LKML <linux-kernel@vger.kernel.org>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
References: <20090309142407.GB18058@denkbrett.schottelius.org> <AFAB8585072C7E48BC5C6F9C87F9B797072E3362@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
In-Reply-To: <AFAB8585072C7E48BC5C6F9C87F9B797072E3362@pdsmsx502.ccr.corp.intel.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc7-next-20090306-ikn x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Luo, Ximin [Tue, Mar 10, 2009 at 09:05:02AM +0800]:
> Hello Nico,
>=20
> This issue is caused by memory allocation failure when allocating rx memo=
ry in isr. (From Yi's point) If you are interested in tracking it, please r=
eport a bug at http://www.intellinuxwireless.org/bugzilla/ for further trac=
king.

http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=3D1933

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--WhfpMioaduB5tiZL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm3mRIACgkQuL75KpiFGIzoEQCgtgpOUfukOHMi0KUE9k0tk6jO
avYAoMOzJjwdS89vY03i0SxDX6wyzrV5
=Nuys
-----END PGP SIGNATURE-----

--WhfpMioaduB5tiZL--
