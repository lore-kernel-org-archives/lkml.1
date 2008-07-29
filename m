Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYG2MqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYG2MqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYG2MqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:46:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47411 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYG2MqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:46:09 -0400
Date: Tue, 29 Jul 2008 22:45:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-Id: <20080729224556.bcdf582a.sfr@canb.auug.org.au>
In-Reply-To: <20080729.033342.21049184.davem@davemloft.net>
References: <20080729.031005.203132019.davem@davemloft.net>
	<20080729192834M.fujita.tomonori@lab.ntt.co.jp>
	<20080729103146.GA32407@elte.hu>
	<20080729.033342.21049184.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Jul_2008_22_45_56_+1000_RZbBp/BXQfb/x1HK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Jul_2008_22_45_56_+1000_RZbBp/BXQfb/x1HK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Jul 2008 03:33:42 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 29 Jul 2008 12:31:46 +0200
>=20
> > i've queued up your quick fix in tip/x86/urgent to resolve the immediat=
e=20
> > -git build breakage. The wider patch can then be done on top of that,=20
> > without being rushed. Any objections to this approach?
>=20
> I do not object :-)

Neither do I. :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Jul_2008_22_45_56_+1000_RZbBp/BXQfb/x1HK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiPEQQACgkQjjKRsyhoI8xNZwCfY3P7QCLB6HRFLuc/V0PStl/u
xNgAn0UdWxTaWsI8nU+hRiYwh+txTdTg
=ftIL
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Jul_2008_22_45_56_+1000_RZbBp/BXQfb/x1HK--
