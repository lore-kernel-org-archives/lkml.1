Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZKWCEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZKWCEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 21:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZKWCEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 21:04:46 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49649 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068AbZKWCEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 21:04:45 -0500
Date: Mon, 23 Nov 2009 13:04:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
Message-Id: <20091123130441.b450278d.sfr@canb.auug.org.au>
In-Reply-To: <20091122.171932.74107512.davem@davemloft.net>
References: <20091123120052.dd388203.sfr@canb.auug.org.au>
	<20091122.171932.74107512.davem@davemloft.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__23_Nov_2009_13_04_41_+1100_YRVRs5JiLpi/dfRe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Nov_2009_13_04_41_+1100_YRVRs5JiLpi/dfRe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sun, 22 Nov 2009 17:19:32 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> Hmmm... I specifically remember taking core of this conflict when I
> merged net-next-2.6 into net-2.6 yesterday or the day before.

These are the trees I picked up from master.kernel.org this morning:

$ git branch -r -v | grep '^ *net'
  net-current/master                                  5d09e53 netxen : fix =
BOND_MODE_TLB/ALB mode.
  net/master                                          e994b7c tcp: Don't ma=
ke syn cookies initial setting depend on CONFIG_SYSCTL

commit e994b7c901ded7200b525a707c6da71f2cf6d4bb
Author: David S. Miller <davem@davemloft.net>
Date:   Sat Nov 21 11:22:25 2009 -0800

Did you push them out?  master was down for a while yesterday ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__23_Nov_2009_13_04_41_+1100_YRVRs5JiLpi/dfRe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksJ7bkACgkQjjKRsyhoI8ycdACgu/KOfCYZ65uD4isonVtvfuEQ
viMAoIE1mCzL/HiqTmttUkNHH6thboxW
=Hrz+
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Nov_2009_13_04_41_+1100_YRVRs5JiLpi/dfRe--
