Return-Path: <linux-kernel-owner+w=401wt.eu-S934960AbZLGNQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934960AbZLGNQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934890AbZLGNQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:16:46 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:60032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067AbZLGNQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:16:44 -0500
Subject: Re: linux-next: net/wireless/wireless-current tree build warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20091201133524.32756cef.sfr@canb.auug.org.au>
References: <20091201133524.32756cef.sfr@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5IpdUsu3hd9G4ZhW3C0e"
Date: Mon, 07 Dec 2009 14:15:54 +0100
Message-ID: <1260191754.3737.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5IpdUsu3hd9G4ZhW3C0e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

> drivers/net/wireless/iwlwifi/iwl-tx.c: In function 'iwl_tx_agg_stop':
> drivers/net/wireless/iwlwifi/iwl-tx.c:1356: warning: passing argument 1 o=
f 'ieee80211_stop_tx_ba_cb_irqsafe' from incompatible pointer type
> include/net/mac80211.h:2128: note: expected 'struct ieee80211_vif *' but =
argument is of type 'struct ieee80211_hw *'

This has now snuck into wireless-testing as well.

johannes

--=-5IpdUsu3hd9G4ZhW3C0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLHQAGAAoJEODzc/N7+QmammYQAKwmmhjwZQAQf5945EmoZGGv
43WpTXgnIoeRrPFjyxuRBuaNEc6l6SrtUxmDWbB0TQINP6yHo9P7+kzyFKUjNgHT
1n5tJbnWRZP2FQmLCmfz6u+HXWptJzKmwd/NU4nisPsK1RV5f+1F53Qs47ka+h5f
TSrx7WoM2hTIkCpRGH3KctlM9/LCnQNzX0oUvAXWRCoOC08SzsfzjXouypvqoSW9
4T1t1LOxYX9VN3TefG8mmR5ZySinVd7S/pwmHk8l7swHNIn2+UIWB1PN73Gd2Xso
AuXoj12Z7z2PyUh3V/WqIsW58B3DWLUyKkrWKeIhV19J4U2mqQ18UAd/dVhKLZ2y
m10E1aPjLp/zRRlzBJuVwKPdQLamYDiqbyb3m+1phU7HAaFN7eyhLo8ky6dYgzJ+
e8PMjgQkTRw6ZgBbPRrE5NC3d7ZUNBhaNlg1nGWM9QNcCaLXZxZ9w7FHKSbQE+MW
qOvDqHtWZjpKrzNKtco88GguvS7D/2/qGF9rvYdvF6BDOHai/aiRfJck5YkYIW/Q
fU7KrakeQIbs1rV3z1XdGKY4ik9ZOawB2tVDJfbezg9NYX8XThlS8MwcBs594mm1
xJjhP5cNF9Q4qJHYR1nX2QkZO3K0hn+JYH+Mqk3jr0rxLlzjyL9SINlBrRWc6z7C
d8FHl6POr7/q9lYclc/Y
=LvwX
-----END PGP SIGNATURE-----

--=-5IpdUsu3hd9G4ZhW3C0e--

