Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYDLAF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYDLAF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 20:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbYDLAFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 20:05:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36484 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbYDLAFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 20:05:48 -0400
Date: Sat, 12 Apr 2008 10:05:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jochen Friedrich <jochen@scram.de>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org
Subject: Re: [PATCHv2 3/7] i2c: OF helpers for the i2c API
Message-Id: <20080412100536.5f0589df.sfr@canb.auug.org.au>
In-Reply-To: <47FFBA7B.8050900@scram.de>
References: <47FFBA7B.8050900@scram.de>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__12_Apr_2008_10_05_36_+1000_5VUSnM44M+3qOdk7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__12_Apr_2008_10_05_36_+1000_5VUSnM44M+3qOdk7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Apr 2008 21:22:35 +0200 Jochen Friedrich <jochen@scram.de> wrote:
>
> This patch implements various helpers to support OF bindings for
> the i2c API.
>=20
> Signed-off-by: Jochen Friedrich <jochen@scram.de>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__12_Apr_2008_10_05_36_+1000_5VUSnM44M+3qOdk7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH//zUTgG2atn1QN8RAjRvAJ4kzEMylk8uOFwwMIbuEpawKlMMQgCfXvSH
YKY0iFd/fDtauTTaR8vb6TA=
=ZgwY
-----END PGP SIGNATURE-----

--Signature=_Sat__12_Apr_2008_10_05_36_+1000_5VUSnM44M+3qOdk7--
