Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZIPHhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZIPHhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZIPHhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:37:12 -0400
Received: from mail.klingt.org ([86.59.21.178]:47739 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbZIPHhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:37:11 -0400
Message-ID: <4AB09562.3010501@klingt.org>
Date: Wed, 16 Sep 2009 09:36:02 +0200
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3pre) Gecko/20090810 Lightning/1.0pre Shredder/3.0b4pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.31-rc5 regression: hd don't show up
References: <h63737$b2a$1@ger.gmane.org> <4A852BC0.1090404@kernel.org> <4A8559D7.6090405@klingt.org> <4A8774E5.4070609@kernel.org> <4A87D9FC.9070408@klingt.org> <4A96460F.3020600@kernel.org> <4A965E3B.3000808@klingt.org> <4A966F7D.60707@kernel.org> <4A97B9C0.9090003@klingt.org> <4A9B7E1E.8060909@kernel.org> <4A9DAF78.4070703@klingt.org> <4A9DD6D9.50407@kernel.org> <4A9E371A.5040208@klingt.org> <4A9FCD8C.6010107@kernel.org> <4AA18F57.8030107@klingt.org> <4AA1ACF8.7030101@kernel.org> <4AA6C569.9090901@klingt.org> <4AB04B39.7030907@kernel.org> <4AB079FC.6000906@kernel.org>
In-Reply-To: <4AB079FC.6000906@kernel.org>
X-Enigmail-Version: 0.96a
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7F57BB0344928FCDB369FA56"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2b1 (klingt.org [127.0.0.1]); Wed, 16 Sep 2009 09:36:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7F57BB0344928FCDB369FA56
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

> Can you please try the attached patch and report the result?  The bug
> shouldn't happen now and for cases where it would have happened,
> libata will report "link online but device misclassified" and retry.

this patch cannot be applied onto stable-2.6.31/master ... e.g. the
first chunk is already in there ....

tim

--=20
tim@klingt.org
http://tim.klingt.org

Every word is like an unnecessary stain on silence and nothingness
  Samuel Beckett


--------------enig7F57BB0344928FCDB369FA56
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqwlW8ACgkQdL+4qsZfVsv/iQCfSjxXovt8Obhaa6nXnxZWAsHg
3HgAn079B0owjE3rWDrw2ZbW2SGrxUu0
=2Npq
-----END PGP SIGNATURE-----

--------------enig7F57BB0344928FCDB369FA56--
