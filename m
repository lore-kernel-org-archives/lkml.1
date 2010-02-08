Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab0BHD7F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 22:59:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52570 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab0BHD7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 22:59:03 -0500
Date: Mon, 8 Feb 2010 14:58:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, sri@us.ibm.com
Subject: Re: linux-next: build failure after merge of the net tree
Message-Id: <20100208145855.6c0be2fe.sfr@canb.auug.org.au>
In-Reply-To: <20100207.194022.53074897.davem@davemloft.net>
References: <20100208132243.ab967d9c.sfr@canb.auug.org.au>
	<20100207.194022.53074897.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__8_Feb_2010_14_58_55_+1100_q8VbyCnYxScggbwu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Feb_2010_14_58_55_+1100_q8VbyCnYxScggbwu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sun, 07 Feb 2010 19:40:22 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> Known problem, I'm fixing it by killing the config option,
> everyone should have that thing enabled by now.

OK, thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__8_Feb_2010_14_58_55_+1100_q8VbyCnYxScggbwu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktvi/8ACgkQjjKRsyhoI8zWPACcCsaAP/dG7CbeQYna62/mf0r4
ZioAn3kFuXhaIZnC9mxGEQ0O+Bq/p1po
=8hp1
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Feb_2010_14_58_55_+1100_q8VbyCnYxScggbwu--
