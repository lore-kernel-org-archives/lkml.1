Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbZHTTAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbZHTTAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZHTTAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:00:44 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:32886 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZHTTAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type;
        b=KcPsLDn1rkUUbwQpMsrb3fxhKsGaZmiICw4WXzbU2eynNjNU6PbaJlTtcWxSFEXCVF
         NK9V79e4y1AZHRvsMIdCSZ/Nd2eAngUmoZowkFQAs7k4EY6vBKdkaKeHvGrobrTFwUin
         15XykphWhnbGYxXTZu83ZlTEIOEKsrucof8bc=
Message-ID: <4A8D9D56.5080107@gmail.com>
Date: Thu, 20 Aug 2009 15:00:38 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: perf: Problem compiling /tools/perf/Documentation in 2.6.31-rc6
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCDB37B6C69FB9EFF274A1790"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCDB37B6C69FB9EFF274A1790
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

I'm seeing this in 2.6.31-rc6:

ghaskins@dev:~/sandbox/git/fabric/linux-2.6/tools/perf/Documentation> mak=
e
    SUBDIR ../
make[1]: `PERF-VERSION-FILE' is up to date.
    ASCIIDOC perf-examples.html
ERROR: perf-examples.txt: line 1: manpage document title is mandatory
FAILED: perf-examples.txt: line 8: illegal style name: From an e-mail by
Ingo Molnar
make: *** [perf-examples.html] Error 1

It could very well be pilot error.  Any ideas?

Kind Regards,
-Greg


--------------enigCDB37B6C69FB9EFF274A1790
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqNnVcACgkQP5K2CMvXmqH7iACggOUwDhlulcBdgbGu6SaQz3gr
sOIAn0540ORYIX2FlHRh7plsyv2lJjRj
=J14A
-----END PGP SIGNATURE-----

--------------enigCDB37B6C69FB9EFF274A1790--
