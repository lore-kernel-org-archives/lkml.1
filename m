Return-Path: <linux-kernel-owner+w=401wt.eu-S1763532AbXGKMBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763532AbXGKMBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762301AbXGKMAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:00:45 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:41371 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758386AbXGKMAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:00:43 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 22:00:42 +1000
User-Agent: KMail/1.9.6
Cc: rjw@sisk.pl, a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu, pavel@ucw.cz,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707111350.41806.rjw@sisk.pl> <E1I8amY-00009H-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I8amY-00009H-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2591624.7gdUpcTcKD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707112200.43613.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2591624.7gdUpcTcKD
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Wednesday 11 July 2007 21:54:58 Miklos Szeredi wrote:
> Freezing of tasks is slowing down suspend.  Don't know how serious
> this is, suspend is pretty fast, but could possibly be even faster.

It's FUD. Freezing of tasks normally takes next to no time. I've never=20
understood the rediculously long timeout it has. If freezing succeeds, all=
=20
processes are frozen within 1/2 a second tops. If it fails, nothing is goin=
g=20
to change in the following 19.5 seconds (or whatever it is if I don't=20
remember the value properly).
=20
Regards,

Nigel


--nextPart2591624.7gdUpcTcKD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGlMZrN0y+n1M3mo0RAnbiAKDGZzYn572tkG6q+lZMOP3Sv/yF5ACgwUR7
dutSJpgEem0Hb8w0/uN4hFA=
=GTi3
-----END PGP SIGNATURE-----

--nextPart2591624.7gdUpcTcKD--
