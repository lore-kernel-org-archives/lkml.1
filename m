Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbZJSRE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbZJSRE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 13:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZJSREz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 13:04:55 -0400
Received: from mail.klingt.org ([86.59.21.178]:35736 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbZJSREz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 13:04:55 -0400
Message-ID: <4ADC9C2A.5020707@klingt.org>
Date: Mon, 19 Oct 2009 19:04:42 +0200
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5pre) Gecko/20091017 Lightning/1.0pre Shredder/3.0pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: pref record question
X-Enigmail-Version: 0.96a
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCECC82AB95A106DB96E8A45C"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Mon, 19 Oct 2009 19:04:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCECC82AB95A106DB96E8A45C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

i am trying to do some profiling with perf (2.6.31.4). while
thread-level profiling works fine, i haven't been able to record
profiling data of a whole process (i.e. main thread + child threads).
from my understanding, this should be enabled by running 'perf record
-i' on the main thread. this does only collect the data from the main
thread, though.

is this an issue with perf or with my understanding of perf?

thanks, tim

--=20
tim@klingt.org
http://tim.klingt.org

art is short - life is long
  Jack Kerouac



--------------enigCECC82AB95A106DB96E8A45C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrcnCoACgkQdL+4qsZfVsvxPwCfTZK3AoLltvn0a98Hdd7RklGN
RdUAoIpvZR0VxrmEjZZWNX8qe2V/Rl03
=oGre
-----END PGP SIGNATURE-----

--------------enigCECC82AB95A106DB96E8A45C--
