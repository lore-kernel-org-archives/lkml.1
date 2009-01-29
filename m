Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbZA2UAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbZA2UAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZA2UAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:00:38 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:37601 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZA2UAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:00:38 -0500
Subject: Re: circular locking dependency on shutdown
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, cpufreq@vger.kernel.org
In-Reply-To: <1233255049.4067.12.camel@johannes.local>
References: <1233255049.4067.12.camel@johannes.local>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ugcHkaOBqFaN3BbnBrs1"
Date: Thu, 29 Jan 2009 20:54:07 +0100
Message-Id: <1233258847.4012.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ugcHkaOBqFaN3BbnBrs1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-29 at 19:51 +0100, Johannes Berg wrote:
> Hi,
>=20
> Every time I shut down my machine with a 2.6.29-rc2 kernel,

Seems it's gone in -rc3, sorry for the noise!

johannes

--=-ugcHkaOBqFaN3BbnBrs1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgglcAAoJEKVg1VMiehFYD7UP/A+ovi0OEsKN88Fu1A5+a7Ok
27bZ1lVyyykDlgQJXCT7QMZazdSs12yNO8aTtlnZrM0/OH8n/znYwpBERLYIFmm2
cDY7bODl/v3w9qif2EBet1RIbkmp69VQ8biwagQuuYenfPIGVO2mYyuUcH1fFIWv
DgvW8Rffa+G4gnc3eO2w81DA2vI/QQi8csJLWMeO3Goq7RBjRjH5dzswzxzqYnMR
7adSLYrmuwXZGT2HW1OP+E6INPIMGEJFGLBlnsla7ZvrAKSvHTdyJbZOW2cT2vZj
rIryDIiPna/zVbDc/ZG+r4/Gk04FWbVJKo1Wk7cwNlj8rnfO/mCOQmBCTUA6RT0W
AleCi1+Lih6q30N3PjtY8Y1vAqLCn6apz+R9EIgdcjiAzIeJEP2uQpJ3UpGFDj/5
oZYlEsx2htOGS1tRbOvi6eMcWbB780w874Wq6hwTfrBPJfEA9iVEN1hcV+jXw41b
9Y4BiD7G44QApwgZaXYicXWsJgMoI+P+uA1CGiKP1teJGP4AVR8wYCV2w2FaaWX3
yorOc1cT4I3K9m4biAyHH7/2j0NtWDOGS775f2XguFtIzsFhpDKZDp80cj/eBrgy
bfrplFAz9LFZrH6WLxNLuA4culy/FP0RSlIj3hx0MeUj8R/X1fVFd6D7131okcLK
3OvEhx8oOTs3DSpCMLXW
=eirL
-----END PGP SIGNATURE-----

--=-ugcHkaOBqFaN3BbnBrs1--

