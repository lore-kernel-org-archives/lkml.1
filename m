Return-Path: <linux-kernel-owner+w=401wt.eu-S934577AbZLGWQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934577AbZLGWQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934004AbZLGWQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:16:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54074 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933458AbZLGWQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:16:37 -0500
Date: Tue, 8 Dec 2009 09:16:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: input tree build failure
Message-Id: <20091208091639.bb3569d1.sfr@canb.auug.org.au>
In-Reply-To: <20091207173640.GA998@core.coreip.homeip.net>
References: <20091207200344.01323cb5.sfr@canb.auug.org.au>
	<4B1D2C80.4060202@oracle.com>
	<20091207173640.GA998@core.coreip.homeip.net>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Dec_2009_09_16_39_+1100_vVPobnhKzYc6YnOx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Dec_2009_09_16_39_+1100_vVPobnhKzYc6YnOx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

On Mon, 7 Dec 2009 09:36:41 -0800 Dmitry Torokhov <dmitry.torokhov@gmail.co=
m> wrote:
>
> I removed the stray EXPORT_SYMBOL(), shold be good now.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Dec_2009_09_16_39_+1100_vVPobnhKzYc6YnOx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksdfscACgkQjjKRsyhoI8zggACgu2Aa2l9JhIKfIDZFNbr5DYse
f3kAn3M03n9iyuNP7ld3zzgGpoVaJKNN
=HwVb
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Dec_2009_09_16_39_+1100_vVPobnhKzYc6YnOx--
