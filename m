Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZBMJgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZBMJgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbZBMJgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:36:32 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:50611 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZBMJgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:36:31 -0500
Date: Fri, 13 Feb 2009 10:36:29 +0100
From: Nico Schottelius <nico-linux-20090209@schottelius.org>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Nico Schottelius <nico-linux-20090209@schottelius.org>,
       Linux Next Mailing List <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] X200: Resume and iwlwifi on
	2.6.29-rc4-ikn-00001-gd5b5623
Message-ID: <20090213093629.GB10175@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090209@schottelius.org>,
	reinette chatre <reinette.chatre@intel.com>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net" <ipw3945-devel@lists.sourceforge.net>
References: <20090209093507.GA27678@denkbrett.schottelius.org> <20090210070147.GA4684@denkbrett.schottelius.org> <1234468120.30608.30.camel@rc-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <1234468120.30608.30.camel@rc-desk>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc4-ikn-00211-g37bed90 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

reinette chatre [Thu, Feb 12, 2009 at 11:48:40AM -0800]:
> Sorry that I missed responding to your email in all the messages
> regarding this problem. A patch was recently sent to address it - could
> you please try with
> http://marc.info/?l=3Dlinux-wireless&m=3D123429595818495&w=3D2 ?

I just booted 2.6.29-rc4-ikn-00211-g37bed90, which contains
that commit, but has broken brightness. I'll test it with
the next version the brightness is working again, currently
local usage of the notebook is not possible :-/

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmVPx0ACgkQuL75KpiFGIzhxACgxkG766FFWxAdk2CEqoqQCEgS
xqwAnihVAzhvLGnJk36xZgmVNkRhfZ8e
=JW7P
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
