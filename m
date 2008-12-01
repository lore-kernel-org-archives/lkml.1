Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYLAEss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYLAEss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 23:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYLAEsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 23:48:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39972 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbYLAEsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 23:48:39 -0500
Date: Mon, 1 Dec 2008 15:48:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: mmotm 2008-11-29-01-53 uploaded
Message-Id: <20081201154819.29339d5b.sfr@canb.auug.org.au>
In-Reply-To: <200812011507.33677.rusty@rustcorp.com.au>
References: <200811290959.mAT9xuhC004277@imap1.linux-foundation.org>
	<20081201111040.42b2a908.kamezawa.hiroyu@jp.fujitsu.com>
	<200812011507.33677.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Dec_2008_15_48_19_+1100_HygW8HbIVVPMmUdi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Dec_2008_15_48_19_+1100_HygW8HbIVVPMmUdi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Dec 2008 15:07:33 +1030 Rusty Russell <rusty@rustcorp.com.au> wro=
te:
>
> Yep, it was mine.  Latest linux-next should have the fix (sfr berated me =
for
> this bug earlier), which is below:

Clearly there should be more public be(r)atings :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Dec_2008_15_48_19_+1100_HygW8HbIVVPMmUdi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkzbJMACgkQjjKRsyhoI8zTlQCfWIEXgD/uo3QjmXFtQ+O9WnvQ
EWkAn30aGyi3j0vL0x5o3Bi0aAtgtL+W
=hBwe
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Dec_2008_15_48_19_+1100_HygW8HbIVVPMmUdi--
