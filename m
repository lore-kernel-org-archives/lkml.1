Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0BELtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 06:49:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37427 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab0BELtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 06:49:19 -0500
Date: Fri, 5 Feb 2010 22:49:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, nicholasx.d.nunley@intel.com
Subject: Re: linux-next: build failure after merge of the net tree
Message-Id: <20100205224911.d6b089e5.sfr@canb.auug.org.au>
In-Reply-To: <20100204.223255.146893399.davem@davemloft.net>
References: <20100205165059.0b5d5363.sfr@canb.auug.org.au>
	<20100204.223255.146893399.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__5_Feb_2010_22_49_11_+1100_KU75_Hlq_bBdonsn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Feb_2010_22_49_11_+1100_KU75_Hlq_bBdonsn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 04 Feb 2010 22:32:55 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> Damn namespace pollution, this is one of a zillion reasons
> I prefer drivers are written in one sorce file, then people
> can name their functions however they like and they're all
> marked static so it doesn't cause problems like this.
>=20
> I've fixed it up as follows in net-next-2.6

Looks good, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__5_Feb_2010_22_49_11_+1100_KU75_Hlq_bBdonsn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktsBbcACgkQjjKRsyhoI8yI6ACdEU60Y5WDizRAvjbVKhHGw6Vv
gCcAnRephHf7qNNaGiLGakB2s2KGKRTu
=qRnG
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Feb_2010_22_49_11_+1100_KU75_Hlq_bBdonsn--
