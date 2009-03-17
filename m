Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZCQCAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZCQCAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 22:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZCQCAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 22:00:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41736 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbZCQCAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 22:00:18 -0400
Date: Tue, 17 Mar 2009 13:00:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-03-16
Message-Id: <20090317130009.19e2dbd8.sfr@canb.auug.org.au>
In-Reply-To: <20090316231423.GA3633@tuxdriver.com>
References: <20090316231423.GA3633@tuxdriver.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_Mar_2009_13_00_09_+1100_U0KhvqZyqHeRo.Xk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Mar_2009_13_00_09_+1100_U0KhvqZyqHeRo.Xk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Mon, 16 Mar 2009 19:14:24 -0400 "John W. Linville" <linville@tuxdriver.c=
om> wrote:
>
> The first one from Luis fixes bug 12110 at bugzilla.kernel.org.  I know
> he has worked on it for a long time and I've had several desperate users
> asking for it, so it must be good. :-)  Unfortunately, it causes some
> nasty merge errors with what is in net-next-2.6 and wireless-next-2.6.
> I created a merge-test branch in wireless-next-2.6, and the merge commit
> log goes into more detail about resolving the issue.  In short, you
> probably want to diff drivers/net/ath9k against the merge-test branch...

I resolved the conflicts as you suggested (hopefully).

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Mar_2009_13_00_09_+1100_U0KhvqZyqHeRo.Xk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm/BCkACgkQjjKRsyhoI8zztQCguqAeGRTxChEEKS/Og6ton0p9
PXAAn3pPDQq4NR6HwqN6PMedITNEmWBT
=T7zP
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Mar_2009_13_00_09_+1100_U0KhvqZyqHeRo.Xk--
