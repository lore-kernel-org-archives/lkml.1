Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZKLKu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZKLKu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZKLKu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:50:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38510 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbZKLKu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:50:56 -0500
Date: Thu, 12 Nov 2009 21:50:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: linux-next: rr tree build failure
Message-Id: <20091112215055.25405fc3.sfr@canb.auug.org.au>
In-Reply-To: <1258016520.2140.329.camel@pasglop>
References: <20091112190308.443d97a3.sfr@canb.auug.org.au>
	<1258016520.2140.329.camel@pasglop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Nov_2009_21_50_55_+1100_GusNWkD_jNf+rZcx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Nov_2009_21_50_55_+1100_GusNWkD_jNf+rZcx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Thu, 12 Nov 2009 20:02:00 +1100 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> Thanks. Our EXPORTs are bogus (probably leftovers) it seems. I'll dbl
> check tomorrow but that looks like a patch I should pickup in powerpc
> -next anyways.

That was the idea, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Nov_2009_21_50_55_+1100_GusNWkD_jNf+rZcx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr76I8ACgkQjjKRsyhoI8yvAQCeOBxfl9MaJNSiimwVyVoNMYdM
ZcwAoJcuKSpgUOQ0f34B+12Bh6R5Kyuz
=/e+g
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Nov_2009_21_50_55_+1100_GusNWkD_jNf+rZcx--
