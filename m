Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZKZVji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZKZVji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 16:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZKZVjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 16:39:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57353 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbZKZVjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 16:39:36 -0500
Date: Fri, 27 Nov 2009 08:39:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: nfs/nfsd trees fetch failed
Message-Id: <20091127083936.b9c125c6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Nov_2009_08_39_36_+1100_TcCL.aUiKDw+c4Np"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Nov_2009_08_39_36_+1100_TcCL.aUiKDw+c4Np
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next fetch of the nfs and nfsd trees produced this error:

git.linux-nfs.org[0: 141.212.112.37]: errno=3DConnection timed out
fatal: unable to connect a socket (Connection timed out)

This also happened yesterday.

I will use the version of these trees from next-20091125 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Nov_2009_08_39_36_+1100_TcCL.aUiKDw+c4Np
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksO9ZgACgkQjjKRsyhoI8yHeACgjojx17oEV7MovMH6SjqlXrnW
vf4AnR3rY/JtOq7CutyiHXkkdoqJbIpz
=LFo6
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Nov_2009_08_39_36_+1100_TcCL.aUiKDw+c4Np--
