Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZJaNrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZJaNrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 09:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757752AbZJaNq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 09:46:59 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35113 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830AbZJaNq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 09:46:59 -0400
Subject: Re: OOPS in cfg80211_conn_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0910310936110.5317@parag-laptop>
References: <f7848160910291617q2b168089l5ce489d2f47ebe96@mail.gmail.com>
	 <1256885343.3555.0.camel@johannes.local>
	 <alpine.DEB.2.00.0910300652350.2223@parag-laptop>
	 <1256903425.3555.47.camel@johannes.local>
	 <f7848160910301622t2cf43b5bo5ffeda03ec2cdbfe@mail.gmail.com>
	 <1256970899.3555.86.camel@johannes.local>
	 <alpine.DEB.2.00.0910310936110.5317@parag-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mNsOvD3G8MnSwhRrj0ez"
Date: Sat, 31 Oct 2009 14:47:01 +0100
Message-ID: <1256996821.3555.132.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mNsOvD3G8MnSwhRrj0ez
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 09:37 -0400, Parag Warudkar wrote:
>=20
> On Sat, 31 Oct 2009, Johannes Berg wrote:
> >=20
> > iw event -t -f > /tmp/log
>=20
> Here it goes - this is while trying couple times to reproduce the issue.

Thanks. I'll analyse it later and if I see any issues fix them.

johannes

--=-mNsOvD3G8MnSwhRrj0ez
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7D/SAAoJEODzc/N7+Qma3hYP/ReiTtMQzPZ45tdCEsLW+gvY
CWFgUjXSUB58gvICPoClXW+8VO7BY6DlpvjkhhhczHlkAvlIdVXMo14p821VnRBK
+qQBZPyqxmZ/vETdyxhHQS1lyNkV3Aekg/pPMfnp0fTr5Kdqvi7thmgCOVeGC/Kh
xB2g15SXvHFLdTRfZDmwUuG3Su4Nqy7eA9KRhXyAj/RlT/eAO5z+4T+82x7qu5/J
uvAEvyv0Y/4MEuwzb55KUvMzwGRYNZVMPBnIi/L+EtglYRxFls6YR3/8MC2cNUjK
xs1we8sWS6ywUcobYrk7F3vQfcBSlAahfLPtp3i64u1Et7JR3EAf5USCD8nDhYP/
eRJjDopMRxI3H8pFNPSOGIJec4mMkRjHQmtJJ9wWQhab5ViW63knyWY3E9eQojol
n2mG+MNwzmKAY3I2RfjTsGfMfz8BaSNxVHERibRI49G6qMnBzJ4Gu9LMfPLdLeN2
purfdf4oz7SGo9qxni37D/Vt6BgKjge5U/DSSoN9C/0cj7wcY2FC7iNKlUXTkXb+
IZcLq4mFLvZDDObZHOiWtOLWPnJH2TzlSDWqBWJngsCDxt2q7ST8a3iqT9CHJUK/
/gprXq+4ucfwqyN3TydiZnzAPxt6Sox20TXIWMyfWMJztsxT6Th3eP8tNXzQV3Uj
XK1GWkDcPYLDCOl4qYjB
=3tNQ
-----END PGP SIGNATURE-----

--=-mNsOvD3G8MnSwhRrj0ez--

