Return-Path: <linux-kernel-owner+w=401wt.eu-S936988AbZLHX0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936988AbZLHX0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936954AbZLHX0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:26:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33860 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935902AbZLHX0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:26:00 -0500
Date: Wed, 9 Dec 2009 10:25:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: hwpoison tree build failure
Message-Id: <20091209102547.c6f03d75.sfr@canb.auug.org.au>
In-Reply-To: <20091208095147.GS18989@one.firstfloor.org>
References: <20091208191418.79270012.sfr@canb.auug.org.au>
	<20091208095147.GS18989@one.firstfloor.org>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Dec_2009_10_25_47_+1100_MFJx/B6QC.R1tkxM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Dec_2009_10_25_47_+1100_MFJx/B6QC.R1tkxM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

On Tue, 8 Dec 2009 10:51:47 +0100 Andi Kleen <andi@firstfloor.org> wrote:
>
> Ah these symbols need to be exported and made sure to be enabled
> in the Kconfig. Thanks I'll fix and push out a new tree.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Dec_2009_10_25_47_+1100_MFJx/B6QC.R1tkxM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkse4HsACgkQjjKRsyhoI8zE4QCff21oCNhtau1O46cYkElKcD6w
wpEAoK97WhEOEe4THeFC1bWBmwWBNZm8
=uX2N
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Dec_2009_10_25_47_+1100_MFJx/B6QC.R1tkxM--
