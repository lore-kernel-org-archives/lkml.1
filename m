Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZELUIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZELUIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZELUIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:08:24 -0400
Received: from blaine.gmane.org ([80.91.229.8]:58997 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbZELUIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:08:23 -0400
Date: Tue, 12 May 2009 19:46:31 +0200
From: Evgeni Golov <sargentd@die-welt.net>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Jiri Slaby 
	<public-jirislaby-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
       Justin Mattock 
	<public-justinmattock-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
       Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       public-ath9k-devel-xDcbHBWguxHbcTqmT+pZeQ@hugh.gmane.org,
       public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Subject: Re: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
In-Reply-To: <dd18b0c30905120728v156d4e1g808a853d23ba0ae6@mail.gmail.com>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com>
	<4A089E49.7080403@gmail.com>
	<20090512103905.0D68E1FD10@chi.die-welt.net>
	<dd18b0c30905120728v156d4e1g808a853d23ba0ae6@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_May_2009_19_46_31_+0200_uGTH6y+TQGxqsURk"
Message-Id: <20090512174636.8EBDA1FD10@chi.die-welt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--Signature=_Tue__12_May_2009_19_46_31_+0200_uGTH6y+TQGxqsURk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 12 May 2009 07:28:04 -0700 Justin Mattock wrote:

> > Same here with 2.6.30-rc4, b43 and either Cisco (MAC-Addr starts with
> > 00:40:96) or HP ProCurve (??? - they do WiFi? - MAC-Addr starts with
> > 00:1F:FE) APs. No encryption, quite noisy environment (University).
> >
> > No problem with ipw2200 (actually 2915) in the same hardware (Thinkpad
> > X31). Neither with the b43 and a standard Linksys WRT54GL (in the same!
> > noisy university-env).
> >
> > Regards
> > Evgeni
> >
> >
>=20
> are you able to connect?
> (or is the connection connecting but really
> poor quality?)
> over here 2.6.29-rc8 connects like
> theirs no tomorrow, as soon as
> I throw in 2.6.30-rc4 it just dead(although
> on some accounts I did get some kind of
> reaction, but not much, just what I see in dmesg).

2.6.29: fairly stable, even if not as good as with an intel card.
2.6.30-rc4: tons of timeouts, may connect 1 in 100 tries, connection
will drop after some (short) time.

--=20
Bruce Schneier Fact Number 79:
Bruce Schneier once decrypted a box of AlphaBits.

--Signature=_Tue__12_May_2009_19_46_31_+0200_uGTH6y+TQGxqsURk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoJtfcACgkQJKAUGKwVtQxZawCfcxexHk55eXn/JNxOemhyyX13
f18AnAm14ZXwmzLDRIP8CfQQpRCbbYbc
=AglB
-----END PGP SIGNATURE-----

--Signature=_Tue__12_May_2009_19_46_31_+0200_uGTH6y+TQGxqsURk--

