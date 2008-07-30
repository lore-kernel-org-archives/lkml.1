Return-Path: <linux-kernel-owner+w=401wt.eu-S1762382AbYG3Pkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762382AbYG3Pkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYG3Pkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:40:33 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:43775 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYG3Pkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:40:32 -0400
Date: Wed, 30 Jul 2008 17:40:28 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mpm@selenic.com, akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080730174028.67184ea2@surf>
In-Reply-To: <20080730142754.GD19966@cs181140183.pp.htv.fi>
References: <20080729154520.728594017@free-electrons.com>
	<20080729154747.872888047@free-electrons.com>
	<20080729181751.GA24924@parisc-linux.org>
	<20080730142754.GD19966@cs181140183.pp.htv.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KkKrxzsZy/AgKq_3jGyWbPG";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KkKrxzsZy/AgKq_3jGyWbPG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Wed, 30 Jul 2008 17:27:54 +0300,
Adrian Bunk <bunk@kernel.org> a =C3=A9crit :

> It seems the emails containing the patches never made it to the vger=20
> lists, which makes it a bit hard to comment on them.

Yes, they didn't make it to the lists, for some reason. Maybe it's
because I sent them using "quilt mail --send", which uses my local
exim4 mail server, and for some reason, vger doesn't like that kind of
e-mails. However, my exim4 is configured to sent the e-mails through by
ISP SMTP. From my exim4 mainlog:

2008-07-29 17:47:57 1KNrQS-0007kt-Kg =3D> linux-kernel@vger.kernel.org R=3D=
smarthost T=3Dremote_smtp_smarthost H=3Dsmtp.free.fr [212.27.48.4]*
2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> linux-embedded@vger.kernel.org R=3D=
smarthost T=3Dremote_smtp_smarthost H=3Dsmtp.free.fr [212.27.48.4]*
2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> netdev@vger.kernel.org R=3Dsmarthos=
t T=3Dremote_smtp_smarthost H=3Dsmtp.free.fr [212.27.48.4]*
2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> davem@davemloft.net R=3Dsmarthost T=
=3Dremote_smtp_smarthost H=3Dsmtp.free.fr [212.27.48.4]*
2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> mpm@selenic.com R=3Dsmarthost T=3Dr=
emote_smtp_smarthost H=3Dsmtp.free.fr [212.27.48.4]*
2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> akpm@linux-foundation.org R=3Dsmart=
host T=3Dremote_smtp_smarthost H=3Dsmtp.free.fr [212.27.48.4]*
2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> thomas.petazzoni@free-electrons.com=
 R=3Dsmarthost T=3Dremote_smtp_smarthost H=3Dsmtp.free.fr [212.27.48.4]*
2008-07-29 17:47:57 1KNrQS-0007kt-Kg -> michael@free-electrons.com R=3Dsmar=
thost T=3Dremote_smtp_smarthost H=3Dsmtp.free.fr [212.27.48.4]*
2008-07-29 17:47:57 1KNrQS-0007kt-Kg Completed

So from my side, everything seemed to work well. Does anybody has a
clue ?

> Thomas, can you try to figure out what went wrong and resend them
> then?

I will send them again through my normal MUA, using quilt mail --mbox.
Hopefully it'll work.

Sincerly,

Thomas
--=20
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com

--Sig_/KkKrxzsZy/AgKq_3jGyWbPG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIkIts9lPLMJjT96cRAu+gAKCSr8z5X4fgX7KGFQ4svShUTmPovwCfQD0m
i1EN/4GQJAdVZZwhE2QxjY8=
=OwXs
-----END PGP SIGNATURE-----

--Sig_/KkKrxzsZy/AgKq_3jGyWbPG--
