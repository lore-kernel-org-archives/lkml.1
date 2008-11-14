Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYKNHuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYKNHuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYKNHu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:50:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40217 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYKNHu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:50:27 -0500
Date: Fri, 14 Nov 2008 18:50:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Can you add the staging tree to -next?
Message-Id: <20081114185016.0097d4eb.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0811140825410.11953@anakin>
References: <20081112235600.GA27554@kroah.com>
	<Pine.LNX.4.64.0811140825410.11953@anakin>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__14_Nov_2008_18_50_16_+1100_eqiIfzh4W8nWKlSQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Nov_2008_18_50_16_+1100_eqiIfzh4W8nWKlSQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Fri, 14 Nov 2008 08:42:48 +0100 (CET) Geert Uytterhoeven <geert@linux-m6=
8k.org> wrote:
>
> Apart from the patches you receive against -next, is there any other
> advantage, giving staging is disabled?

Others compile linux-next with all sorts of configs, so we hopefully will
see any build failures.  In fact, Greg might even built it with staging
enabled :-)

We will also see any merge conflicts (though there probably won't be
many).

I may also see if I can arrange for a build in each architecture with
staging enabled in my infrastructure here, but it may take a little while.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Nov_2008_18_50_16_+1100_eqiIfzh4W8nWKlSQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkdLbgACgkQjjKRsyhoI8woAQCglBkmHLYg5q+XAbcwuov3aX0p
S0sAn1BTUT8nuYR4HbhvR3R3dhPuLlIX
=yUED
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Nov_2008_18_50_16_+1100_eqiIfzh4W8nWKlSQ--
