Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXEDP2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXEDP2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933140AbXEDP2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:28:40 -0400
Received: from home.keithp.com ([63.227.221.253]:1766 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127AbXEDP2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:28:39 -0400
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
From: Keith Packard <keithp@keithp.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: keithp@keithp.com,
       Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <4240b9160705040240q2a325845tf81686ae17912ff2@mail.gmail.com>
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
	 <1178137279.53297.114.camel@vonnegut>
	 <46391860.3070409@tungstengraphics.com>
	 <1178251621.27028.9.camel@neko.keithp.com>
	 <463AE9AE.7070806@tungstengraphics.com>
	 <4240b9160705040149v3c97413fg54f1486f55ffbc11@mail.gmail.com>
	 <4240b9160705040240q2a325845tf81686ae17912ff2@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xZuAK8WyPt4mXmzEc/oq"
Date: Fri, 04 May 2007 08:28:13 -0700
Message-Id: <1178292493.27028.42.camel@neko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xZuAK8WyPt4mXmzEc/oq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-04 at 11:40 +0200, Jerome Glisse wrote:

> On a side note i think this scheme also fit well with gpu having
> several context and which doesn't need big validation (read
> nv gpu).

Yeah, I want to make sure we have a simple model that supports
multi-context hardware while also avoiding failing over badly when we
have more users than hardware contexts.

--=20
keith.packard@intel.com

--=-xZuAK8WyPt4mXmzEc/oq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGO1ENQp8BWwlsTdMRAvX8AJ0eea76slDmpKyybZ3X2FIVhpSYYACZAQft
4gtxLFR0iH70AFGrhFJtkqA=
=Wu1M
-----END PGP SIGNATURE-----

--=-xZuAK8WyPt4mXmzEc/oq--
