Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZG1P2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZG1P2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZG1P2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:28:19 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZG1P2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:28:18 -0400
Subject: Re: [Bug #13337] [post 2.6.29 regression] hang during suspend of
 b44/b43 modules
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Scholz <scholz@fias.uni-frankfurt.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Tomas Janousek <tomi@nomi.cz>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <87my6ovpjv.fsf@scholz.fias.uni-frankfurt.de>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	 <87k52izvd9.fsf@scholz.fias.uni-frankfurt.de>
	 <87y6qxx50z.fsf@scholz.fias.uni-frankfurt.de>
	 <200907092203.10294.rjw@sisk.pl> <1247171295.1905.5.camel@johannes.local>
	 <87prc78ga9.fsf@scholz.fias.uni-frankfurt.de>
	 <1247322985.30647.108.camel@johannes.local>
	 <8763dznnki.fsf@scholz.fias.uni-frankfurt.de>
	 <1247334464.30647.109.camel@johannes.local>
	 <87my6ovpjv.fsf@scholz.fias.uni-frankfurt.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RFvgE9pBbYlgRXxuYTdD"
Date: Tue, 28 Jul 2009 17:26:17 +0200
Message-Id: <1248794777.8113.13.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RFvgE9pBbYlgRXxuYTdD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-28 at 16:40 +0200, Jan Scholz wrote:

> The bug is still present in v2.6.31-rc4, it's still fixed by the patch
> (see below) suggested as a test by Johannes.

Sorry, this completely dropped off my radar, I'll take a look today.
Thanks for reminding me.

johannes

--=-RFvgE9pBbYlgRXxuYTdD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbxiWAAoJEODzc/N7+QmaltcQAI1fx5Hh4REfEqLPex8pw+DV
jxKdz50ibMx5Vqw30gyDn/6vYTbc+xI7R2uKzj1j4be0tyhrmVDPgMnn9l6k1Lg9
J/MA66ucotWpf6VuH26aptjIPwZixMDTkB4JTzMKmM/l5UZoz3MhQCCjf5y5vjBv
CaClot5on7YEgF5Qkbl5TSVkT8Ky+acY+IOhvKqFkryOXaR9VaWHfm8+M4IARSge
/0sXFAWch+tdf7FSs1ZnPflkWbZgyvSozgl8xrerGNvXJlqjbB3bi62tpDJ4naoO
ZSIe4353ysdbMhPF8dBHNuQ/1/eyZk8SzJVz/PXpFqlXxgFi+5KrhW4AQlB+A/yq
3SAKW4jxBfseuEwMuSmU3q14/w7FFL6GlHRviKx1ATJAi86qmwx1qRS6xw4i1SCg
FkkOV6dFEHa9eHjVO/D1fKedD1P/54q2GZM/mBLVJBYvRZlHYEAAlCjbpHH/TvrZ
yr/3pb7aRoUu2Ul3AuacpBugBMLb6G7eLxKNCzzF6sEDgVH5LeXr4HC7TpJhFIRs
0J91XH0dZWNIEm8m/Z1/D/iPSn/4UoJl1+TU4YPXYB1lg2XAhOkZupJZufLZtanv
W7FRdOBfwacv2Nzr9TZfOBlPwIizYK5CPgop9Jkh8LXmnwFlROm+XGecrHtzdk0v
QYRinTPYEKhyJ6pL1PVo
=v7K6
-----END PGP SIGNATURE-----

--=-RFvgE9pBbYlgRXxuYTdD--

