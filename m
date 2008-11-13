Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYKMXoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYKMXoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYKMXof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:44:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60150 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbYKMXoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:44:34 -0500
Date: Fri, 14 Nov 2008 10:44:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Can you add the staging tree to -next?
Message-Id: <20081114104421.772feee3.sfr@canb.auug.org.au>
In-Reply-To: <20081112235600.GA27554@kroah.com>
References: <20081112235600.GA27554@kroah.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__14_Nov_2008_10_44_21_+1100_Cx_0lKbC2GlOpmi+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Nov_2008_10_44_21_+1100_Cx_0lKbC2GlOpmi+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 12 Nov 2008 15:56:00 -0800 Greg KH <greg@kroah.com> wrote:
>
> I'm starting to get people sending me patches against -next for the
> drivers/staging/ tree that don't apply as -next does not include my
> quilt tree of staging patches.
>=20
> Can you please pick it up?  You can put it at the end of your series,
> and the 'make allmodconfig' option disables building anything in the
> drivers/staging/ subdirectory, so it should not have any build or merge
> conflicts with anything.
>=20
> It can be found at:
> 	http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-st=
aging/
> and is a quilt tree.
>=20
> It will follow all the same rules as other trees, with patches only for
> the next merge window (2.6.29 right now) in it.

OK, I have added it starting today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Nov_2008_10_44_21_+1100_Cx_0lKbC2GlOpmi+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkcu9UACgkQjjKRsyhoI8wM8QCgt77NbngIabJKAjj2B+mt7PRm
uNQAn0sC3t9qVAZ1uyVlIlWy6U1oed9F
=6j92
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Nov_2008_10_44_21_+1100_Cx_0lKbC2GlOpmi+--
