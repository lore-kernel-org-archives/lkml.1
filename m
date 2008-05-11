Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbYEKTmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbYEKTmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbYEKTmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:42:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:54166 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756105AbYEKTmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:42:14 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX1/xD7c5TuXxK+3p5jSx3GrPv5WDn03f6dluW6BuAb
	Rcao3cV1kpFtA0
Subject: Re: BUG: scheduling while atomic: events/1/10/0x00000002 on
	linux-next
From: Mirco Tischler <mt-ml@gmx.de>
To: Tomas Winkler <tomasw@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Reinette Chatre <reinette.chatre@intel.com>, Zhu Yi <yi.zhu@intel.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1ba2fa240805111226s6f900015n4144f5411957ef2a@mail.gmail.com>
References: <1210524139.17521.5.camel@mtlp.tischlernetz>
	 <1ba2fa240805111226s6f900015n4144f5411957ef2a@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/RUH5g1hwl1ebttekIbt"
Date: Sun, 11 May 2008 21:39:38 +0200
Message-Id: <1210534778.5052.3.camel@mtlp.tischlernetz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/RUH5g1hwl1ebttekIbt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> What exact git tree is this?
>   iwlcore:iwl_send_cmd_sync+0x154/0x24b waits for event so something
> has changed in mac80211. Need to see the code.
>=20
> Thanks
> Tomas
>=20
This is Stephen's linux-next tree from 2008-05-09. Checkout tag
next-20080509.

--=-/RUH5g1hwl1ebttekIbt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIJ0t6z+diZ7c2xfgRAnatAJ0eJcC0viauVKtl5ymYsxEfH/7TnACfYFsS
03z4KRUNwbQzeH0pOJsqDx0=
=CJNn
-----END PGP SIGNATURE-----

--=-/RUH5g1hwl1ebttekIbt--

