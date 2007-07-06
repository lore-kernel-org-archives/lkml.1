Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbXGFFyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbXGFFyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 01:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbXGFFxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 01:53:54 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:47221 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbXGFFxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 01:53:53 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 15:53:50 +1000
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20070703042916.GA17240@srcf.ucam.org> <200707061403.15932.nigel@nigel.suspend2.net> <CF605B91-2425-4FC2-9434-5F8877EEEEEB@mac.com>
In-Reply-To: <CF605B91-2425-4FC2-9434-5F8877EEEEEB@mac.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7541905.DmvDLvAnoK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707061553.51036.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7541905.DmvDLvAnoK
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Kyle.

On Friday 06 July 2007 15:01:48 Kyle Moffett wrote:
> On Jul 06, 2007, at 00:03:15, Nigel Cunningham wrote:
> > The kind of thing Linus was talking about would limit you (as =20
> > swsusp and uswsusp do now) to only half the amount of memory.
>=20
> How so?  Suppose hibernate is implemented like this:

You're not talking about the same thing Linus was suggesting. He was just=20
wanting a result =3D sys_snapshot() sort of call. That would limit us to ha=
lf=20
the amount of memory.

I've looked over what you've written below and want to consider it in detai=
l.=20
Right now though, I don't have the time. I'll try to get back to you=20
promptly.

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart7541905.DmvDLvAnoK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjdjvN0y+n1M3mo0RAnciAKDWR3LtY9IPQr7wEtSuzcvDMpnJnQCg9QKI
EHjZuAo5lsdesim/eT0ANNg=
=ptAy
-----END PGP SIGNATURE-----

--nextPart7541905.DmvDLvAnoK--
