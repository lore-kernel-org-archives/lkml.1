Return-Path: <linux-kernel-owner+w=401wt.eu-S1423538AbXBPKKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423538AbXBPKKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423541AbXBPKKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:10:08 -0500
Received: from mail33.syd.optusnet.com.au ([211.29.132.104]:44466 "EHLO
	mail33.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423538AbXBPKKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:10:07 -0500
From: Con Kolivas <kernel@kolivas.org>
To: ck mailing list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: 2.6.20-ck1
Date: Fri, 16 Feb 2007 20:10:00 +1000
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Message-Id: <200702162110.03355.kernel@kolivas.org>
X-Length: 2613
Content-Type: multipart/signed;
  boundary="nextPart1440127.v6PBsh06un";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1440127.v6PBsh06un
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This patchset is designed to improve system responsiveness and interactivit=
y.=20
It is configurable to any workload but the default -ck patch is aimed at th=
e=20
desktop and -cks is available with more emphasis on serverspace.

Apply to 2.6.20
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.20/2.6.20-=
ck1/patch-2.6.20-ck1.bz2

or server version
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.20/2.6.20-=
ck1/patch-2.6.20-cks1.bz2

web:
http://kernel.kolivas.org

all patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/


Split patches available.

=46ull patchlist:

sched-staircase-17.patch
sched-staircase17_interactive_tunable.patch
sched-staircase17_compute_tunable.patch
sched-range.patch
sched-iso-4.7.patch
track_mutexes-1.patch
sched-idleprio-1.1.patch
sched-limit_policy_changes.patch
sched-make_softirqd_batch.patch
cfq-ioprio_inherit_rt_class.patch
cfq-iso_idleprio_ionice.patch
hz-default_1000.patch
hz-no_default_250.patch
sched-add-above-background-load-function.patch
mm-swap_prefetch-34.patch
mm-convert_swappiness_to_mapped.patch
mm-lots_watermark.diff
mm-kswapd_inherit_prio-1.patch
mm-prio_dependant_scan-2.patch
mm-background_scan-2.patch
mm-idleprio_prio.patch
mm-filesize_dependant_lru_cache_add.patch
kconfig-expose_vmsplit_option.patch
ck1-version.patch


=E3=81=93=E3=81=AE=E3=82=AB=E3=83=BC=E3=83=8D=E3=83=AB=E3=81=AF=E7=AB=8B=E6=
=B4=BE=E3=81=A0=E3=81=A8=E6=80=9D=E3=81=84=E3=81=BE=E3=81=99=E3=82=88

=2D-=20
=2Dck

--nextPart1440127.v6PBsh06un
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF1YL7ZUg7+tp6mRURAn2UAJ4kNDMuaKTMSo49tudZ1RvvVeGFewCfcDUm
EY53To7RSM2VwNomNfq6vWM=
=iPN8
-----END PGP SIGNATURE-----

--nextPart1440127.v6PBsh06un--
