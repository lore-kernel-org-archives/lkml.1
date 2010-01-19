Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285Ab0ASUTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0ASUTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208Ab0ASUTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:19:52 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:56162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab0ASUTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:19:52 -0500
X-Greylist: delayed 1593 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jan 2010 15:19:51 EST
Subject: Re: [ipw3945-devel] hang on 2.6.33-rc4
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Norbert Preining <preining@logic.at>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1263920481.4838.32.camel@rchatre-DESK>
References: <20100115152215.GC2541@gamma.logic.tuwien.ac.at>
	 <1263576588.2751.455.camel@rc-desk>
	 <20100119054715.GA10780@gamma.logic.tuwien.ac.at>
	 <1263920481.4838.32.camel@rchatre-DESK>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EZJeI0leTrqd5vb+Ag8u"
Date: Tue, 19 Jan 2010 18:59:50 +0100
Message-ID: <1263923990.28066.3.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EZJeI0leTrqd5vb+Ag8u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-01-19 at 09:01 -0800, reinette chatre wrote:

> > If you want me to create a bug report or you create one in bugzilla,
> > I can also upload it htere, but I attach it for now.
>=20
> I see that it fails in skb_pull after being called from one of the RX
> handlers. Let's add Johannes.
>=20
> Johannes, does anything perhaps look familiar to you in this trace?

Sorry, no, seems weird. The trace is not very useful unfortunately, is
this with CONFIG_FRAME_POINTER?

johannes

--=-EZJeI0leTrqd5vb+Ag8u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLVfMSAAoJEODzc/N7+QmaF0UP/i8O9VZnqT44lJuNq0Bs9RBs
b9q+bHBYGglZOC9l7i15yGXm2QKN9NwyNuYLVnpxC+N2XV6bnt6WcLRJls9b+60z
LoOEpXDHhoVQ1K6hg+I1LEsEXSBbaOBv8rTHXd42sXuZRWBAwt2mQZ6NKAYa15UF
WRfMfKplVkAZjXSleqX49za6exp9ESxYBNPxSg9Wj0g3dW7C38DWbN8bfULA/qde
dupKRHBmkUU/0vH93iNY5jCtF+0wnjVFXmJ7QC0bL7vSTXiUlUt3J5Z37W7vv7/1
k/q46gH4FImKs+uSbjNjleyFbwpuHG0br4qjvlhrLjwBYauvsgOk8AZWI+RN/Ffl
pMEMfvph7IeytK7x1Kguqr/DaBipCfcFLJkmuwHfgai/ic6IrS2KR86jjGdyDtmg
33LWHRUxSUb+8pFk6H18OjYwdSGKJiRpgb21DWj9Eaw/AICG8Mbokd8lnqyZMU5K
2tkPW1AVVIuaNTca0OjH100GYbBEnCBPNeo/EQWEiG450W5GQ8OHxvUEf4nWfpMC
ZKu8hO9k85jb17heqbbb0TABrRt5EI0ZCxXE2B+RSJ3OD/FjFyTXQXNQE9GyjPP+
4MGdlccQGltZrd2FOBIY9CneMgFS4HJz+IhJYU0su+rhY5E+txVFeAhfsuHaoJdy
j18J+uZ+y4d3TIlhNk2S
=1y7P
-----END PGP SIGNATURE-----

--=-EZJeI0leTrqd5vb+Ag8u--

