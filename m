Return-Path: <linux-kernel-owner+w=401wt.eu-S1764380AbXGKMtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764380AbXGKMtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762842AbXGKMtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:49:35 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:44889 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762590AbXGKMtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:49:32 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 22:49:48 +1000
User-Agent: KMail/1.9.6
Cc: Miklos Szeredi <miklos@szeredi.hu>, a1426z@gawab.com, jeremy@goop.org,
       jbms@cmu.edu, pavel@ucw.cz, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <E1I8amY-00009H-00@dorka.pomaz.szeredi.hu> <200707111419.11418.rjw@sisk.pl>
In-Reply-To: <200707111419.11418.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1817257.ClcVaKPLlA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707112249.50363.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1817257.ClcVaKPLlA
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Wednesday 11 July 2007 22:19:10 Rafael J. Wysocki wrote:
> The sync probably slows down more than the freezing itself ...

Absolutely. Waaaay more. Maybe it would help if you popped in some printks=
=20
that help people see that it's not the freezer taking a long time, but=20
syncing?
=20
Nigel

--nextPart1817257.ClcVaKPLlA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGlNHuN0y+n1M3mo0RAi+wAKCH25r7FyvO2om9CiqokiudbVoQqwCgtmI1
gSdT+URbnOseNFuVt2/drak=
=HD2F
-----END PGP SIGNATURE-----

--nextPart1817257.ClcVaKPLlA--
