Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZDTFFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZDTFFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 01:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZDTFEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 01:04:51 -0400
Received: from apollo.i-cable.com ([203.83.115.103]:35093 "HELO
	apollo.i-cable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753188AbZDTFEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 01:04:50 -0400
Date: Mon, 20 Apr 2009 13:04:20 +0800
From: Zhang Le <r0bertz@gentoo.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@hofr.at>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       zhangfx@lemote.com, loongson-dev@googlegroups.com, yanh@lemote.com,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-rt-users@vger.kernel.org
Subject: Re: "RT_PREEMPT for loongson" is updated to patch-2.6.29.1-rt8
Message-ID: <20090420050419.GA22520@adriano.hkcable.com.hk>
Mail-Followup-To: Wu Zhangjin <wuzhangjin@gmail.com>,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@hofr.at>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	zhangfx@lemote.com, loongson-dev@googlegroups.com, yanh@lemote.com,
	Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
	linux-rt-users@vger.kernel.org
References: <1240193547.25532.52.camel@falcon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <1240193547.25532.52.camel@falcon>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi, Zhangjin,

Ralf told me he has a ftrace implementation too.

11:47 < Ralf> r0bertz: ftrace looks nice but not yet mergable yet.
11:47 < Ralf> r0bertz: I also have my own ftrace implementation which in so=
me
parts is better, in some is worse.=20
11:47 < Ralf> r0bertz: So this is going to be quite a job. =20

So I think you can talk to Ralf about how to get this merged, :)

--=20
Zhang, Le
Gentoo/Loongson Developer
http://zhangle.is-a-geek.org
0260 C902 B8F8 6506 6586 2B90 BC51 C808 1E4E 2973

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknsAlMACgkQvFHICB5OKXP8FACgjDtvahfiKVOXeBVoi4RDq22y
TGwAoITlCsglF5WzSujLFiECiM3YVA8V
=QGmr
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
