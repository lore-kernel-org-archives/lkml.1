Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbXKBKce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbXKBKce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 06:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbXKBKc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 06:32:28 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:55491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXKBKc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 06:32:27 -0400
Subject: Re: [linux-pm] [RFC][PATCH 1/3] Suspend: Testing facility
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200711012358.27919.rjw@sisk.pl>
References: <200711012357.27797.rjw@sisk.pl>
	 <200711012358.27919.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XH3R5JIuLv+FH2fiCm2q"
Date: Fri, 02 Nov 2007 10:33:46 +0000
Message-Id: <1193999626.25744.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XH3R5JIuLv+FH2fiCm2q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> 5 - test the freezing of processes

> +/* Suspend test levels */
> +enum {
> +	TEST_NONE,

Without reading the code, I assume that this enum controls those levels.
I think a comment that it is user-space visible API and should not be
reordered would be warranted.

johannes

--=-XH3R5JIuLv+FH2fiCm2q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyr9CaVg1VMiehFYAQKz5g/+MfER8HDO3LUWcgywC7RFBthKlJbBJqnb
d4zojvyem8WpXWRE3GhChODTtgIs9Szb0I17ESIONcY8ZUe5a7KNfqo3mfgDuyla
afSs4Ruhg7Qp4oslKSp84ie7wS62K3YwyUXWAvUrMJoGbQ38lMosB0FOnxIUEPG+
t2Vu/BldYFxd2YfNkrmuHjVlfGZZQK9LpqFA9PmvAgIOjPfPaWj1jURAAPd8YrO7
KFoqUXCBA9sAiOnUb8J0/3JAY+KjkipeX8AUViAwu8pAprjzkHVj2yXnR4c2ETpF
VgTox2/O4VH4y5UcMURNzJcx/6D72ongAyL5p9yWMYaMhTckVMA9GW4P5jkVAAUb
i6MPgnK1gkWWMjSLR+to/HhO9w0WqUMBFESqEukuJC9J1sT7NxMCEPB/SCWywI4+
piwdVHDLp1EjI1JZPa3EmTW0WIkRBzwUQcqQ4nj64XQf2IAl9j+yzPMeT/wwIHVn
70oqoLtWKsGdLbew3OdyBKj5vdQrqB9IvOyiuD/qE3QvxxLtqb4FlTmpVUZmcHqp
v1UY1O1xWm03zjyboZaqJs5HThPMvtTjK35lIq6EU/uzvrGGiFEh84SRmR0owHzv
3PwcUtH2D0Sr2ruvfWL4+PTRbTezGh1TbVst1pw/EJeYe514u/R8e8qjCGn3u7Mu
RfX+4h3Vlfw=
=nXcR
-----END PGP SIGNATURE-----

--=-XH3R5JIuLv+FH2fiCm2q--

