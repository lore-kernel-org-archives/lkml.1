Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbZFCQ1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbZFCQ1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZFCQ1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:27:31 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbZFCQ1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:27:30 -0400
Subject: Re: linux-next: Tree for June 3 (rfkill)
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A269539.8020607@oracle.com>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
	 <4A269539.8020607@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-N6EotFSpetdxPWbtZMMX"
Date: Wed, 03 Jun 2009 18:27:21 +0200
Message-Id: <1244046441.4862.32.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N6EotFSpetdxPWbtZMMX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 08:22 -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Looks like a real rush since -rc7 ...
>=20
>=20
> CFG80211=3Dy
> MAC80211=3Dy
> RFKILL=3Dm

Hmm. I see, it's mac80211's broken select CFG80211. I'll fix it.

johannes

--=-N6EotFSpetdxPWbtZMMX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJqRmAAoJEODzc/N7+Qma2CAP/0tJxOkS04n6m1xJ2UWE53ax
Yjz5MwWOq4LJzHQlLbo86vlkBCOyznqxdWVtWrDNazKxnsFkUi5IWvE7j57unw7b
EovR8neplGtFTvPeDIEh7U3BTgFGdO7YhUOwJxpLr/5qSllvtKHZDRKE5SW38WGM
fi2CBRNM1yKO6HLbONRs9U2wToOw+4zzVMElSZc/5XeiO26Uy2Vcw8pAKje6xYjy
wlPu3N+x+AhOTVj9/RkQkJx3BSzMJz3aFiP1mbFQ5AZ8LEWQO6vitRb5iE9xwasY
7jGBG9GOdFtVJTWctKjc41tvI+ihUM/D//oLO8TB3Wd0x6EsNCpJniu9cmuBIqOd
5LJDAvd/MRqDTERpl9QeZdEPpR0p2TRo7x2yT6HagpNo5/zj9e2OvnfOCLyzE1+J
DDOjNKjX6FiSDESvlahut+aZjOZnk6gnzFVyu72RlUN76yuQARMAD4Drn6Bwipyg
ufTbsueVdTK7KDMrJX0nZtYJbZN2RSO6U3fAs9/y3vdTvYZFPZ6wdWdbtZz0m0SB
Z3/kTW+AkRsDuIaj/IloFqDzA7ktn9e5cPxPh3TNQeV9lKNBgxtJ7UQ+4bmduOjT
sapeo52Lw7dIWT4tATlDANycIKVnmb6fXmwvOB3F06ifO2GrYroD6Hw9INzhRRIU
aVCF+qMF2lHHuAgusJuh
=x0d9
-----END PGP SIGNATURE-----

--=-N6EotFSpetdxPWbtZMMX--

