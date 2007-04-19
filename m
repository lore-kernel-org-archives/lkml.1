Return-Path: <linux-kernel-owner+w=401wt.eu-S1766833AbXDSQDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766833AbXDSQDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766835AbXDSQDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:03:06 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:35797 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766833AbXDSQDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:03:04 -0400
X-Greylist: delayed 1494 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2007 12:03:04 EDT
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: ck@vds.kolivas.org
Subject: Re: [ck] [ANNOUNCE] Staircase Deadline cpu scheduler version 0.43
Date: Thu, 19 Apr 2007 17:37:34 +0200
User-Agent: KMail/1.9.5
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Al Boldi <a1426z@gawab.com>, Peter Williams <pwil3058@bigpond.net.au>,
       Nick Piggin <npiggin@suse.de>, Matt Mackall <mpm@selenic.com>,
       Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>
References: <200704200112.36465.kernel@kolivas.org>
In-Reply-To: <200704200112.36465.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8659506.KgYSzxqXL3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704191737.55990.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1176998584;4409cebc;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8659506.KgYSzxqXL3
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> In order to keep raising the standard for comparison for the alternative =
new=20
> scheduler developments, here is an updated version of the staircase deadl=
ine=20
> cpu scheduler.

I very much appreciate your continued work on SD.

Over the last days I had used 26.21-rc7-ck1 and -ck2. Today I have
given sd0.42 a try and my system "feels" more responsive with my
everyday tasks. No hard facts just my very subjective usage experience.

I'm on an Intel Core2 T7600 2.33GHz, 4GB, openSUSE 10.2, KDE

Workload are occasional compilejobs as well as regular Perl
numbercrunching scripts while having amarok playing music.

No noticeable desktop freezes or anything else. With -ck1/2 I had
occasional visual freezes/delays.

I think I still like SD better than the "old" -ck.

I'll give 2.6.21-rc7-sd0.43 a try later today (i.e. when it has
finished been built).

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart8659506.KgYSzxqXL3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGJ4zTUYYhyuxDQc4RAkEKAKCCvq02rKFDgd3e8gy0HGRD0ku+wACgqWyO
QwPsQKEsXtYNCGu6mOVWHIU=
=c8hn
-----END PGP SIGNATURE-----

--nextPart8659506.KgYSzxqXL3--
