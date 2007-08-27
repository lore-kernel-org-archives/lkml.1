Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbXH1Ifb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbXH1Ifb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 04:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbXH1IfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 04:35:20 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:59699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbXH1IfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 04:35:17 -0400
Subject: Re: [PATCH 3/4] Net: ath5k, use short preamble for some rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <2109718751164215004@pripojeni.net>
References: <2109718751164215004@pripojeni.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L2Yf9NIDfxBoHXUryo7/"
Date: Mon, 27 Aug 2007 20:09:19 +0200
Message-Id: <1188238159.7837.50.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-L2Yf9NIDfxBoHXUryo7/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-08-25 at 03:58 -0400, Jiri Slaby wrote:
> ath5k, use short preamble for some rates
>=20
> 2, 5.5 and 11 in b/g are now in short preamble mode

umm, mac80211 needs to be able to choose depending on the network.

johannes

--=-L2Yf9NIDfxBoHXUryo7/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0xNO/ETPhpq3jKURArcGAJ93euXVfQaZQ6yNB2ezQFTyfY23ogCfRpWi
eAIloEkrJlRDtxswqG43Dcc=
=RRWC
-----END PGP SIGNATURE-----

--=-L2Yf9NIDfxBoHXUryo7/--

