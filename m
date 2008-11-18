Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYKRVUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYKRVUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYKRVUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:20:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54124 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYKRVUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:20:04 -0500
Date: Wed, 19 Nov 2008 08:19:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: linux-m68k.git
Message-Id: <20081119081951.a1a33403.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0811182136060.27671@anakin>
References: <Pine.LNX.4.64.0811182136060.27671@anakin>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__19_Nov_2008_08_19_51_+1100_jLC8i6D0Jx//GW3."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Nov_2008_08_19_51_+1100_jLC8i6D0Jx//GW3.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Tue, 18 Nov 2008 21:49:01 +0100 (CET) Geert Uytterhoeven <geert@linux-m6=
8k.org> wrote:
>
> (Finally) I created an experimental git tree for Linux/m68k:
> http://git.kernel.org/?p=3Dlinux/kernel/git/geert/linux-m68k.git
>=20
> It contains more or less all patches I had in my quilt series at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-m68k-patches-2.=
6/
> A notable exception is m68k-PRIVATE-m68k-changes.diff, which hardcoded AR=
CH to
> m68k.
>=20
> I also created for-next and for-linus branches. Do they look OK?

They look good.  I have added the for-linus branch as my m68k-current
tree and changed my m68k tree over to the for-next branch.

> If I did something wrong, please let me know.
> This is still experimental stuff, which may be rebased if needed.

That's fine as long as the commits in the for-next branch are: posted
somewhere relevant, reviewed, tested and destined for the next merge
window. (None of these requirements have changed from what should have
been in your quilt tree.)

I expect the for-linus branch to be fixes and stuff for the current
release.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__19_Nov_2008_08_19_51_+1100_jLC8i6D0Jx//GW3.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkjMXcACgkQjjKRsyhoI8zHCwCgjiI+Nso5hfFTXAEB/VGI4Jz5
6QsAn3GHWK8BwBVDsT+9J8JLebGQHhRj
=PfH1
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Nov_2008_08_19_51_+1100_jLC8i6D0Jx//GW3.--
