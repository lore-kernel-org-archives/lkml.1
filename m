Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbZFJLJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbZFJLJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbZFJLJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:09:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48925 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbZFJLJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:09:33 -0400
Date: Wed, 10 Jun 2009 21:09:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Elina Pasheva <epasheva@sierrawireless.com>
Subject: Re: linux-next: manual merge of the usb tree with the ttydev tree
Message-Id: <20090610210926.42314498.sfr@canb.auug.org.au>
In-Reply-To: <20090610110617.58e73a37@lxorguk.ukuu.org.uk>
References: <20090610184114.fe8a849e.sfr@canb.auug.org.au>
	<20090610110617.58e73a37@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_21_09_26_+1000_3WnDEpqusJBSrBXj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_21_09_26_+1000_3WnDEpqusJBSrBXj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Wed, 10 Jun 2009 11:06:17 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> On Wed, 10 Jun 2009 18:41:14 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > Today's linux-next merge of the usb tree got a conflict in
> > drivers/usb/serial/sierra.c between commit
> > 968b6bc702be2b0953212f1ca56b1dc889c1c72d ("tty-usb-sierra-add-urb-funcs=
")
> > from the ttydev tree and various commits from the usb tree.
> >=20
> > There is some overlap between the ttydev patch and the usb patches.  I
> > have just used the version of this file from USB tree (since it seems
> > that there are many more changes there).
> >=20
> > Please sort this out ...
>=20
> Already working on this and getting all the patches into the ttydev tree.
> Sierra are also now checking over my merge to check its ok.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_21_09_26_+1000_3WnDEpqusJBSrBXj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkovlGYACgkQjjKRsyhoI8zCjwCgsqlpoPXh7rRxAbtnYwTzZUaB
+MwAn1TpCvIKxOPj5j8resiIaVGdWGn4
=ndyg
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_21_09_26_+1000_3WnDEpqusJBSrBXj--
