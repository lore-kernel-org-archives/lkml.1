Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab0CFEg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 23:36:58 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:39302 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab0CFEg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 23:36:56 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-hotplug@vger.kernel.org
Subject: Re: Problems with remote-wakeup settings
Date: Sat, 6 Mar 2010 07:36:18 +0300
User-Agent: KMail/1.13.0 (Linux/2.6.33-desktop-1mnb; KDE/4.4.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Oliver Neukum <oliver@neukum.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       linux-input@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1003052314130.10381-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003052314130.10381-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2181245.yYC95H6HeF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201003060736.18555.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2181245.yYC95H6HeF
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Saturday 06 of March 2010 07:16:20 Alan Stern wrote:
> On Fri, 5 Mar 2010, Rafael J. Wysocki wrote:
> > On Friday 05 March 2010, Oliver Neukum wrote:
> > > Am Freitag, 5. M=E4rz 2010 21:59:31 schrieben Sie:
> > > > > I guess it's better if drivers don't set should_wakeup if
> > > > > unsure, but of course that's impossible to enforce.
> > > >=20
> > > > That's the real question.  Ideally, drivers won't touch
> > > > should_wakeup. How do we get there from here?
> > >=20
> > > Enable it only for devices specifically designed for wakeup, that
> > > is keyboards, power buttons and WoL, perhaps also mice and
> > > modems. Are we far away from that?
> >=20
> > I don't think we're very far from that.
> >=20
> > Mice are known dangerous, especially the USB ones, though.
>=20
> I agree, especially for desktop systems.  You don't want the system
> to wake up merely because you happened to jostle the mouse.  That
> happened to me just a few days ago (and it was a PS/2 mouse, not
> USB).

I remember, my old desktop had BIOS option to wake up on mouse click=20
(and it had PS/2 mouse either) ignoring mouse move. I actually found it=20
useful.

--nextPart2181245.yYC95H6HeF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkuR28IACgkQR6LMutpd94yuegCgpfFtMVCw09Qh0dPDNcFu3wil
RL8AnRB0i5bEosIeWXKgcs3/5IthH0io
=uiuN
-----END PGP SIGNATURE-----

--nextPart2181245.yYC95H6HeF--
