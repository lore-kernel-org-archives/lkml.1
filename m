Return-Path: <linux-kernel-owner+w=401wt.eu-S1751758AbZIIF6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbZIIF6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 01:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZIIF6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 01:58:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:34264 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751015AbZIIF6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 01:58:39 -0400
X-Authenticated: #32306085
X-Provags-ID: V01U2FsdGVkX18TIV5FLwcTgWvCzNJ1OZa1zMcX/1VLn0uK5603qA
	Ix3gBre+ID/OCj
From: Christoph Thielecke <christoph.thielecke@gmx.de>
Reply-To: christoph.thielecke@gmx.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #14018] kernel freezes, inotify problem
Date: Wed, 9 Sep 2009 07:58:32 +0200
User-Agent: KMail/1.9.9
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera> <1252273078.27723.0.camel@dhcp231-106.rdu.redhat.com> <200909062351.02664.rjw@sisk.pl>
In-Reply-To: <200909062351.02664.rjw@sisk.pl>
Cc: Eric Paris <eparis@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Paris <eparis@parisplace.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2844453.UKP6nlZWuT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909090758.40514.christoph.thielecke@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2844453.UKP6nlZWuT
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.30.  Please verify if it still should be listed and let me
> > > know (either way).
> > >
> > >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14018
> > > Subject		: kernel freezes, inotify problem
> > > Submitter	: Christoph Thielecke <christoph.thielecke@gmx.de>
> > > Date		: 2009-08-19 12:48 (19 days old)
> > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125068616818353&w=
=3D4
> > > Handled-By	: Eric Paris <eparis@parisplace.org>
> >
> > This should be marked as fixed.
>
> Yeah, I forgot to close it.  Thanks for the heads up.
Right, seems working fine (sorry for the delay I tested a while).


With best regards

Christoph
=2D-=20
Linux User Group Wernigerode
http://www.lug-wr.de/

--nextPart2844453.UKP6nlZWuT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqnRAsACgkQd9JRTD5SjRg8GQCeJCznPmVi9TGzGkOvEEI6G0YI
WxIAoKS1tBgCopLWM/WsfvN9w+JIieDS
=zgyW
-----END PGP SIGNATURE-----

--nextPart2844453.UKP6nlZWuT--
