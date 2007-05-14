Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbXENKai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbXENKai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbXENKaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:30:30 -0400
Received: from mail19.syd.optusnet.com.au ([211.29.132.200]:32851 "EHLO
	mail19.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755583AbXENKaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:30:30 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: 2.6.21-ck2
Date: Mon, 14 May 2007 20:30:12 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1454632.YC0KupIJNQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705142030.14638.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1454632.YC0KupIJNQ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This patchset is designed to improve system responsiveness and interactivit=
y.=20
It is configurable to any workload but the default -ck patch is aimed at th=
e=20
desktop and -cks is available with more emphasis on serverspace.


Apply to 2.6.21
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.21/2.6.21-=
ck2/patch-2.6.21-ck2.bz2

or server version
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.21/2.6.21-=
ck2/patch-2.6.21-cks2.bz2

web:
http://kernel.kolivas.org

wiki:
http://ck.wikia.com

all patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/


This release focuses on the fixes for swap prefetch. Thus if you do not pla=
n=20
to use swap prefetch there is no benefit to upgrading. For those that are=20
using swap prefetch this update is highly recommended


Changes since 2.6.21-ck1:
 -sched-add-above-background-load-function.patch
 +sched-ck-add-above-background-load-function.patch
Update the above_background_load function to work properly with SD cpu=20
scheduler as used in -ck

 +mm-swap-prefetch-35-38.patch
Numerous updates to fix and improve swap prefetch

 -ck1-version.patch
 +ck2-version.patch
Version update


=E6=A5=BD=E3=81=97=E3=81=BF=E3=81=AA=E3=81=95=E3=81=84
Enjoy

=2D-=20
=2Dck

--nextPart1454632.YC0KupIJNQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGSDo2ZUg7+tp6mRURAoH/AJ9cej+vFWd4sEX5aLw2GRKGiconsQCeIvrn
fTqsVlvjHPBEG2tlCbeorq0=
=uR3V
-----END PGP SIGNATURE-----

--nextPart1454632.YC0KupIJNQ--
