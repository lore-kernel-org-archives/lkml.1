Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZGVEuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZGVEuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 00:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZGVEux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 00:50:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60318 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbZGVEux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 00:50:53 -0400
Date: Wed, 22 Jul 2009 14:50:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhu Yi <yi.zhu@intel.com>
Cc: David Miller <davem@davemloft.net>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ortiz, Samuel" <samuel.ortiz@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the net tree with the
 wireless-current tree
Message-Id: <20090722145047.289a7edb.sfr@canb.auug.org.au>
In-Reply-To: <1248228321.3747.48.camel@debian>
References: <20090722115956.482777b4.sfr@canb.auug.org.au>
	<1248228321.3747.48.camel@debian>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__22_Jul_2009_14_50_47_+1000_nMwv+lxBKryi1s9d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Jul_2009_14_50_47_+1000_nMwv+lxBKryi1s9d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yi,


On Wed, 22 Jul 2009 10:05:21 +0800 Zhu Yi <yi.zhu@intel.com> wrote:
>
> The correct fix should be
> http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testing.git=
;a=3Dcommitdiff;h=3D126e91ba8cfe45a772aad2f51049ac7cedf5bbfd
>=20
> We need to make the free wdev the last one.

Thanks, if it is still there tomorrow, I will change the fix.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__22_Jul_2009_14_50_47_+1000_nMwv+lxBKryi1s9d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpmmqcACgkQjjKRsyhoI8w1YACeM+uhEPqopNw0iWJLh7IwRjnx
el0An3f1C6sqz316UC6qj9fcwV0W1B02
=OfX4
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Jul_2009_14_50_47_+1000_nMwv+lxBKryi1s9d--
