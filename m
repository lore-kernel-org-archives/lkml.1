Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYJ0Sbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYJ0Sbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYJ0Sbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:31:31 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYJ0Sba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:31:30 -0400
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
From: Johannes Berg <johannes@sipsolutions.net>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Carlos R. Mafra" <crmafra2@gmail.com>,
       linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <1225130844.4466.0.camel@localhost>
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <200810271832.40717.rjw@sisk.pl>  <1225130844.4466.0.camel@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-neRwo8qyXkIh2DzqgDeJ"
Date: Mon, 27 Oct 2008 19:31:18 +0100
Message-Id: <1225132278.3796.32.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-neRwo8qyXkIh2DzqgDeJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 19:07 +0100, Soeren Sonnenburg wrote:

> > Johannes, can you pls have a look?

I did, and I have no idea. Makes no sense at all.

> Hmmhh, I still have the problem when removing the mac80211 and other
> wireless modules before s2ram...

And that makes even less sense :)

johannes

--=-neRwo8qyXkIh2DzqgDeJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBgjyAAoJEKVg1VMiehFYLoYQALMCjQMdsnzhz1HQSD31b4Eq
kB7NAaPMjzdfwlZyDqadZSmeVNfd6LMMyESGVUay+g7p4AEnA06Pqa7ZK4Zk8PeK
dfUYAbnjzlL/Ll2yt32qL+XZVYL8exR/f4f4EW4d/NYYZDHWtsfhooT7yqDwYRa0
v6zHT5IPo5Ssq1qy/rJSyBbDk/TodsbTwXpYYFuimDUNi9N57LkI+6pxtS3nKeLF
WjM6LfLQSbrpVFlwcWueFNu2OF78zKNMHU7jqFudMojqMqdfA3Vjr35e1ajlnl6t
eIWVO1CcYlZnG/7y6OJ7OX+mXsdPZucvQ6nXERHI14Q5YDW+JW/Mueb0gasF4psG
e58lQTct7q0yY1oBike0oyGpRUUBiUE/DVkVGmIxD8lb8W3BBrvSF+QNmXkZUaP3
w2fBcrCB36cE4u6Pw2H353ieWY9F958TEc+3YzRI395WWF2e3F6bSDf5W42OEZuQ
Ax2pHh2A5BhIU1iXVSrVwoO1/BLmLTP/X+ROVBzJ//jaMYTIGQXvW3C80Dp6LoI2
+5pASUZbztdm1ow0rPnfNd3Gl2sq1l1ERXwO5SwQqJD3cE0E/R06/d8yA+jk5Q/y
cEu3AiOZ0qLwVKtYI6jT8nMRF2AVx/ncw1ltpCbk5bWJ9KEC6l9zSymfPujPhhJl
dYeVN8rjsllLwbQzHPxc
=N19b
-----END PGP SIGNATURE-----

--=-neRwo8qyXkIh2DzqgDeJ--

