Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZKQIQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZKQIQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbZKQIQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:16:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41305 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbZKQIQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:16:53 -0500
Date: Tue, 17 Nov 2009 19:16:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Oliver Hartkopp <oliver@hartkopp.net>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Christian Pellegrin <chripell@fsfe.org>,
       Wolfgang Grandegger <wg@grandegger.com>, Anant Gole <anantgole@ti.com>
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
Message-Id: <20091117191652.615575fe.sfr@canb.auug.org.au>
In-Reply-To: <4B025812.6060807@hartkopp.net>
References: <20091117131637.3a35f898.sfr@canb.auug.org.au>
	<4B025812.6060807@hartkopp.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_Nov_2009_19_16_52_+1100_Xtb=DuGdTuPc1sfB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Nov_2009_19_16_52_+1100_Xtb=DuGdTuPc1sfB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Tue, 17 Nov 2009 09:00:18 +0100 Oliver Hartkopp <oliver@hartkopp.net> wr=
ote:
>
> Yes. You only added the new Kconfig entries (for CAN_TI_HECC, CAN_MCP251X,
> CAN_MSCAN, ...) to the patch "can: Fix driver Kconfig structure", right?

Yes.

> These are the only added items in drivers/net/can/Kconfig from net-2.6 to
> net-next-2.6.

And it looks like Dave will fix this up for me tomorrow.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Nov_2009_19_16_52_+1100_Xtb=DuGdTuPc1sfB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksCW/QACgkQjjKRsyhoI8yKeQCfWWsM+3cyFBAn/zjaIn7Odq3Q
oqgAn1o/AcXJbnmKLtl+mZCSGxo751jU
=U0bA
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Nov_2009_19_16_52_+1100_Xtb=DuGdTuPc1sfB--
