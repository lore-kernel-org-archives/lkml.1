Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbYBKMYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbYBKMYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYBKMYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:24:37 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:49541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbYBKMYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:24:36 -0500
Subject: Re: 2.6.24.x-stable request for
	69f817b654d683265118188bbfb8bc0d8978cce6 and
	ece8edddf067d21c4e5abfe3f1205da1588edbb2
From: Johannes Berg <johannes@sipsolutions.net>
To: caglar@pardus.org.tr
Cc: linux-kernel@vger.kernel.org, flamingice@sourmilk.net, jbenc@suse.cz,
       hschaa@suse.de, yi.zhu@intel.com, linville@tuxdriver.com,
       jgarzik@pobox.com, linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200802110208.58891.caglar@pardus.org.tr>
References: <200802110208.58891.caglar@pardus.org.tr>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Szm/gVPdf2OQjwV6JQyZ"
Date: Mon, 11 Feb 2008 13:21:04 +0100
Message-Id: <1202732464.11481.66.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Szm/gVPdf2OQjwV6JQyZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> On 2.6.24.1-stable kernel review cycle, i requested inclusions of
> commit 69f817b654d683265118188bbfb8bc0d8978cce6 (mac80211: Restore
> rx.fc before every invocation of ieee80211_invoke_rx_handlers)=20

That one I can agree with, it's a trivial fix.

> and ece8edddf067d21c4e5abfe3f1205da1588edbb2 (mac80211: hardware scan
> rework) into -stable one (they solved disable_hw_scan=3D1 workaround for
> wpa_secured hidden AP problem).=20

That one I don't really want to take responsibility for in a stable
cycle.

johannes

--=-Szm/gVPdf2OQjwV6JQyZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7A9r6Vg1VMiehFYAQL0CRAAmi/5WOvJ3MApZ6/aF2sW3zkE3YpiJCMf
Zi8WDdwYnB7wBKe/JA53CFLUqIidJR67GxxrNzSCvdwNMRkhAb4WipN1eZS1miiw
Oumc7D46zBGWRU4nBTEUdnvhgqNVLbWkL3W3P9F8ofEA69Z+mOhmsCb1CDkOjKDi
ebxIqp7iuvraQfb9hjIka7UTjnCw+NdeT9yNetZJrp8pDMNdVrB/xPG++6cWaDjS
E3kxcoEqDk9IW4tBR9wsEo3sphktIfSc4fHUxhIBUPy9Fqr/Z9m4eIEvM8zdArLL
6/Tg3prwVKlhWbUR/l6h7G69LQNYWiC4jEjTnYiLU0OBQHHOnFER1Exv2lbM0uEf
uT2Dt1O+9MbCzGEXHUCI+qMZgDjMUzmPZf/WLEaSLTQotuUJi0cTLstmebTgZKzM
WzCol4ZRGg/ZSEnVlDvivlSt0Et8pZ/NgvLl0gPMm+6XeggAMD4Zu4e89cuLmAYP
hGN2a9KYy6COnQJO1ACkrTWODnJqvL1kHzURLMYx8CER1fibZzKbb+wOAgwT3UDf
VNUSolHq6tRIhdTyeI/dZcQ7B5PDAdrdW2h7TmesgDFoG4ja5NFUsTiK1rBzEnlg
oG9PBoA1lQW9sRgfhft4up+X1NHvDdM07FMemxrtwVdtNlSHvIIGGqXDKM7tCj2J
N0bgVr+fBG4=
=SHfJ
-----END PGP SIGNATURE-----

--=-Szm/gVPdf2OQjwV6JQyZ--

