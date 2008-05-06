Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYEFH1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYEFH1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 03:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYEFH0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 03:26:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56324 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbYEFH0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 03:26:32 -0400
Date: Tue, 6 May 2008 17:26:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, andi@lisas.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mchehab@infradead.org
Subject: Re: Linux 2.6.26-rc1
Message-Id: <20080506172626.20f13363.sfr@canb.auug.org.au>
In-Reply-To: <20080505.235654.232530105.davem@davemloft.net>
References: <20080506095122.860796f6.sfr@canb.auug.org.au>
	<20080505.165501.62584352.davem@davemloft.net>
	<20080506153552.805240f3.sfr@canb.auug.org.au>
	<20080505.235654.232530105.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_May_2008_17_26_26_+1000_FDgCvjOrsg_RTWkt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_May_2008_17_26_26_+1000_FDgCvjOrsg_RTWkt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 05 May 2008 23:56:54 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 6 May 2008 15:35:52 +1000
>=20
> > On Mon, 05 May 2008 16:55:01 -0700 (PDT) David Miller <davem@davemloft.=
net> wrote:
> > > So what should I do now?
> > >=20
> > > I have Ingo's IRDA PNP fixes in my net-2.6 tree and that's already
> > > publicly visible, so I'd need to add revert changesets if people want
> > > me to remove it.
> >=20
> > Do nothing.

Except, of course, make sure that those patches go to Linus. :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_May_2008_17_26_26_+1000_FDgCvjOrsg_RTWkt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIIAgmTgG2atn1QN8RArGEAJ9TJcFnKZ86ebq5TRSxV0Aigtq+6QCfWS1N
EqvnbfA4Pyp3sJPiT/1NRWw=
=VvGN
-----END PGP SIGNATURE-----

--Signature=_Tue__6_May_2008_17_26_26_+1000_FDgCvjOrsg_RTWkt--
