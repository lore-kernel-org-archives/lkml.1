Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYCPTE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYCPTE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYCPTEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:04:51 -0400
Received: from mx40.mail.ru ([194.67.23.36]:59950 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYCPTEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:04:50 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [possible regression] 2.6.22 reiserfs/libata sporadically hangs on resume from hibernation
Date: Sun, 16 Mar 2008 22:04:37 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200706300859.47133.arvidjaar@mail.ru> <200803130708.56282.arvidjaar@mail.ru> <200803132146.42156.rjw@sisk.pl>
In-Reply-To: <200803132146.42156.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8096015.ag1RiMExQV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803162204.44131.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8096015.ag1RiMExQV
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 13 March 2008, Rafael J. Wysocki wrote:
> On Thursday, 13 of March 2008, Andrey Borzenkov wrote:
> >=20
> > For the record - it happened again under 2.6.25-rc5; it reall drives
> > me nuts. Of course every time it happens I do not have infrastructure t=
o use
> > netconsole :( I am about to reformat the whole with ext3 as this seems
> > to always hang somewhere in fs access and looks like not many people
> > use reiser today.
> >
>=20
> Well, it may be related to having the root partition on reiserfs.  I've n=
ever
> seen anything like this with non-root reiserfs partitions ...
>=20

This one looks the hell similar to what I posted and Ingo is using ext3 ...

http://marc.info/?l=3Dlinux-kernel&m=3D120479427912295&w=3D2

--nextPart8096015.ag1RiMExQV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEABECAAYFAkfdb0YACgkQR6LMutpd94ykKACfdTohSKseT+lQT2eHJGjJokfj
sJwAnjNfZ3Yb3HQIr/ODI347zB8o+w0R
=oZFa
-----END PGP SIGNATURE-----

--nextPart8096015.ag1RiMExQV--
