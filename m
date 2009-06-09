Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbZFIJwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbZFIJwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759832AbZFIJwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:52:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41724 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759487AbZFIJwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:52:05 -0400
Date: Tue, 9 Jun 2009 19:52:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: linux-next: manual merge of the rr tree with the  tree
Message-Id: <20090609195200.8344c2f0.sfr@canb.auug.org.au>
In-Reply-To: <20090609135627.944b1851.sfr@canb.auug.org.au>
References: <20090609135627.944b1851.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_19_52_00_+1000_vvLcYji/zJZ0RH1L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_19_52_00_+1000_vvLcYji/zJZ0RH1L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 9 Jun 2009 13:56:27 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the rr tree got a conflict in
> arch/x86/kernel/cpu/mcheck/mce{,_64}.c between commit mce_init_device
> ("x86, mce: Rename sysfs variables") from the  tree and commit
                                               ^^^
x86

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Jun_2009_19_52_00_+1000_vvLcYji/zJZ0RH1L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkouMMAACgkQjjKRsyhoI8yMOACeKWCwogpMGf5sFwGzCwPCdzUx
8BEAoKkiMep+mPYTbGFpOKldcx7pXEN4
=FGml
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_19_52_00_+1000_vvLcYji/zJZ0RH1L--
