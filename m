Return-Path: <linux-kernel-owner+w=401wt.eu-S1762142AbXGOXiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762142AbXGOXiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbXGOXiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:38:15 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:53561 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbXGOXiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:38:14 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Hibernation considerations
Date: Mon, 16 Jul 2007 09:38:13 +1000
User-Agent: KMail/1.9.6
Cc: david@lang.hm, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
References: <Pine.LNX.4.44L0.0707151914450.28934-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707151914450.28934-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1875635.pehxPaokTr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707160938.16037.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1875635.pehxPaokTr
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Monday 16 July 2007 09:15:47 Alan Stern wrote:
> On Sun, 15 Jul 2007 david@lang.hm wrote:
>=20
> > >> for a pure hibernate mode, you will be powering off the box after=20
saving
> > >> the suspend image. why are there any special ACPI modes involved?
> > >
> > > Because, for example, on my machine the status of power supply (prese=
nt
> > > vs not present) is not updated correctly after the restore if ACPI=20
callbacks
> > > aren't used during the hibernation.  That's just experience and it's =
in=20
line
> > > with the ACPI spec.
> >=20
> > so if a machine is actually powered off the /dev/suspend process won't=
=20
> > work?
> >=20
> > remember that the system may run a different OS between the hibernate a=
nd=20
> > the resume, makeing any assumptions about what state the hardware is in=
=20
> > when you start the resume is a problem.
>=20
> As I understand it, running a different OS between the hibernate and=20
> the resume would violate the ACPI spec.

Well then, I know one or two people who would argue that the ACPI spec is=20
faulty. :\

Regards,

Nigel
=2D-=20
Nigel Cunningham
Christian Reformed Church of Cobden
103 Curdie Street, Cobden 3266, Victoria, Australia
Ph. +61 3 5595 1185 / +61 417 100 574
Communal Worship: 11 am Sunday.

--nextPart1875635.pehxPaokTr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGmq/oN0y+n1M3mo0RAgmVAJ9jz67HS+WaZ2TxiNeDbSVbmcsxawCfSOip
zSF7Cboect+TZCUIRWDPHnE=
=H0PZ
-----END PGP SIGNATURE-----

--nextPart1875635.pehxPaokTr--
