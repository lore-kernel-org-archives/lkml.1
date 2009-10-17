Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbZJQPIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbZJQPIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 11:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZJQPIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 11:08:42 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:46287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZJQPIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 11:08:41 -0400
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
From: Johannes Berg <johannes@sipsolutions.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, John Linville <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, users@host1.serialmonkey.com,
       Alban Browaeys <prahal@yahoo.com>,
       Benoit PAPILLAULT <benoit.papillault@free.fr>,
       Felix Fietkau <nbd@openwrt.org>,
       Luis Correia <luis.f.correia@gmail.com>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       Mark Asselstine <asselsm@gmail.com>,
       Xose Vazquez Perez <xose.vazquez@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200910171654.03344.bzolnier@gmail.com>
References: <200910152137.58164.IvDoorn@gmail.com>
	 <200910152204.16407.IvDoorn@gmail.com>
	 <200910171654.03344.bzolnier@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nGMAjkV8uCWHfn4fFx2o"
Date: Sun, 18 Oct 2009 00:08:24 +0900
Message-Id: <1255792104.3434.2.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nGMAjkV8uCWHfn4fFx2o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-17 at 16:54 +0200, Bartlomiej Zolnierkiewicz wrote:

> I also used the opportunity to take a closer look at this driver and
> it seems that it needlessly adds around 2 KLOC to kernel by duplicating
> the common content of rt2800usb.h to rt2800pci.h instead of moving it
> to the shared header (like it is done in the staging crap drivers):

Tell me you're kidding -- comparing 2k duplicated LOC with a driver that
ships its own wifi stack?

johannes

--=-nGMAjkV8uCWHfn4fFx2o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2d3kAAoJEODzc/N7+QmawG8P/iEWM2uicvDfAQn+HVbN8ISz
mDX9UhUx5AEPFgvqcxZR2+lI3pMj6v4fvUlXouozUznX2rrPTIKadDOASLZlrRrc
zz5iO455SdIMIOZCmwYWg+6WRshl0eGSq6nDtzt/oOUf1kVU+YI3kg0CTx5EoRdw
FY/CwcjDEOswrazBBZMZM8nYTegC9+kGosZUmJ4Sib0bQFj6y5GWeCRaNyF805rx
gy4O4FxzBdv+EtfnJ+/sf5tuPe0oBP6o2DsW7jSNvJkFp2wjcBxtm0GyiJfjadIz
nKAF7x2Bg0kAIR44nCETebDnvDjzAHwqA5Nl20CeEIJUvPY+B31WlR6YOXFRTk71
QZig03D63KR2azfRfeZjamRBhW3V8H5mpwDDarYQfv+V63nUtSjt8ElXmIeFheib
FYKg/5OILjp9d6Mp+6pg9LLQoeHYIftbBC/mAMxdffIr+SpZPBqenJCQFo5yfDbC
XGjl7Siekxkwq+Y1I4sCfIK0McA54ZWYbCBtVvcZyJpnaV4HYEQhOt0vOvXnKRiN
B+qnZGcLU3tLlM6ZX1+4qFzMxrsEN8FbFyRUduFNSnvD0pDe/mffla25PJdH6ZBN
v2sT/Pp4dZLiIcHzdYg9IYn+k0JQvVf9k/yAcVh6N8Zilb/jCo+3S8GPbb2Mr9vK
9J6jxwLBmJQ8NM3V/r28
=5wb2
-----END PGP SIGNATURE-----

--=-nGMAjkV8uCWHfn4fFx2o--

