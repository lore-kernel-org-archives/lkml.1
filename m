Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZJZTLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZJZTLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbZJZTLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:11:52 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbZJZTLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:11:50 -0400
Subject: Re: [Bug #14353] BUG: sleeping function called from invalid
 context at kernel/mutex.c:280
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Miles Lane <miles.lane@gmail.com>
In-Reply-To: <6dRYo8ss7vL.A.6gH.Gse5KB@chimera>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <6dRYo8ss7vL.A.6gH.Gse5KB@chimera>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tmbts6C9lmAjplkrBvz5"
Date: Mon, 26 Oct 2009 20:11:46 +0100
Message-ID: <1256584306.4237.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tmbts6C9lmAjplkrBvz5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-26 at 19:55 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14353
> Subject		: BUG: sleeping function called from invalid context at kernel/m=
utex.c:280
> Submitter	: Miles Lane <miles.lane@gmail.com>
> Date		: 2009-10-05 3:39 (22 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D125471432208671&w=3D4

This should be fixed by a160ee69c6a4622ed30c377a978554015e9931cb.

johannes

--=-tmbts6C9lmAjplkrBvz5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5fRtAAoJEODzc/N7+Qmac28P/jOV6DBTEqaNNUsuajYc13FL
yLO6ysVpHrX3OleSdfwn2IL655MMmyreHl1cndhBHFWnUiiiKCBthKBE2103I8zb
vM5SD/1FREdZQDb9pIj/lRc5PHXMFzett95zU3PYA4lH+nBOeccmFKP7/E/8gL7/
M/8XoSW7xk6oiOHXvVtwUD9fEOK2bziPOZ3UIVIXgL6WdcY9oBT8wtco7QTooJBq
btW0yvJp/y98LcC1Rk6RLn0qhLC31Ws1bN8/qKp6e9Gs7pHO3ur8IdsyDg9t/JKs
QxVIT5E07qnmgN4hgiQAmID7d2M+R8+/yrlUpfnTKDomEkhGSIBz0RS+S87lNs7Q
8LWPySZtpqqQLNOIfiubC8FlnqHQfp52BEjOKmm/aSPRmu40mVps0l4fDIONvSao
sKOBdoWaSsFOZIkkUttJSiUUX+dEyC/n6ac6UheHjhWTWjnIJf+6X0XdsKjx+HWO
q/rpn1/KMvrau2BNgYTg8NmcN77BbNPoakJ9lsCZKMr/2TBxo7s/5x/ru0R4eE3v
iPaQgL8sDfDdamOWROmvgNXNwXClNwH2QGn52mdkR52DrUvZNd5zNDRGSpCDcXVQ
fVpDX108msFC62IKpeiXo3EaiJ39ilt3I9AYR8QYy09W7zaqBrQV4WzfVFcE/nzx
obqXbD0AW1UJGSvquMl5
=3g4O
-----END PGP SIGNATURE-----

--=-tmbts6C9lmAjplkrBvz5--

