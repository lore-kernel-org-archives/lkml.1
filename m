Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZLIPLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZLIPLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:11:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZLIPLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:11:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40976 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbZLIPLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:11:00 -0500
Date: Thu, 10 Dec 2009 02:11:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: linux-next: manual merge of the tty tree with the trivial tree
Message-Id: <20091210021100.b606b224.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LNX.2.00.0912091536230.3755@pobox.suse.cz>
References: <20091209162826.a28c6c68.sfr@canb.auug.org.au>
	<alpine.LNX.2.00.0912091536230.3755@pobox.suse.cz>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Dec_2009_02_11_00_+1100_5QTr2fKH/oaeGSYe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Dec_2009_02_11_00_+1100_5QTr2fKH/oaeGSYe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Wed, 9 Dec 2009 15:38:19 +0100 (CET) Jiri Kosina <jkosina@suse.cz> wrote:
>
> On Wed, 9 Dec 2009, Stephen Rothwell wrote:
>=20
> > I just used the tty tree version where they clashed.  Jiri, you might
> > consider sending that patch to Greg for the tty tree.
>=20
> the trivial tree pull request has already been sent to Linus a day ago. I=
=20
> am now waiting whether it will be merged or missed.
>=20
> In the latter case, I will split the tty hunk out and send to Greg. In th=
e=20
> former case the conflict would have to be solved either by Greg or Linus.

OK, that's fine, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Dec_2009_02_11_00_+1100_5QTr2fKH/oaeGSYe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksfvgQACgkQjjKRsyhoI8z5iwCeLSa7JO+y9xvws7q2gcjRTj4m
XoAAn2k2of/8E+Y9ol5ALVlRBJ0jJ/R5
=qkMl
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Dec_2009_02_11_00_+1100_5QTr2fKH/oaeGSYe--
