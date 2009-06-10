Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbZFJILs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbZFJILs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbZFJILf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:11:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47951 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbZFJILe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:11:34 -0400
Date: Wed, 10 Jun 2009 18:11:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: rr tree build failure
Message-Id: <20090610181130.284a5a7f.sfr@canb.auug.org.au>
In-Reply-To: <200906101656.48204.rusty@rustcorp.com.au>
References: <20090609201205.2894522c.sfr@canb.auug.org.au>
	<200906101656.48204.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_18_11_30_+1000_aHoMu6w9N9Un7t76"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_18_11_30_+1000_aHoMu6w9N9Un7t76
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Wed, 10 Jun 2009 16:56:46 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Ah, my bad.  I'll wrap this and test this config too.

Thanks.  I will revert that commit from today's linux-next as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_18_11_30_+1000_aHoMu6w9N9Un7t76
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkovarIACgkQjjKRsyhoI8y/yACfTm5DhFrv4AO9Ud0VDHUmSOin
uMEAniLXodqbR8zxv2f4Iychp6B4k/pz
=A8cl
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_18_11_30_+1000_aHoMu6w9N9Un7t76--
