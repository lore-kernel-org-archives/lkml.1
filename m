Return-Path: <linux-kernel-owner+w=401wt.eu-S934191AbYCFNeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934191AbYCFNeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758367AbYCFNde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:33:34 -0500
Received: from smtp4.int-evry.fr ([157.159.10.71]:47873 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbYCFNdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:33:33 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][x86] rdc321x: remove watchdog file
Date: Thu, 6 Mar 2008 14:24:09 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200802251144.08962.florian.fainelli@telecomint.eu> <20080225105408.GB5648@elte.hu>
In-Reply-To: <20080225105408.GB5648@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8808566.2XYBIHHnaF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803061424.13024.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8808566.2XYBIHHnaF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ingo,

Le lundi 25 f=E9vrier 2008, Ingo Molnar a =E9crit=A0:
> thanks, applied. I guess i should push this change upstream only once
> the new watchdog driver has been committed to drivers/watchdog/ ?

Can you please trigger the patch now. Wim has accepted the RDC built-in=20
watchdog driver. See :=20
http://git.kernel.org/?p=3Dlinux/kernel/git/wim/linux-2.6-watchdog-mm.git;a=
=3Dcommit;h=3Db2de97cf901162e0a5936b2bbdae27ec1e55455d

Thank you very much.

--nextPart8808566.2XYBIHHnaF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHz/B8mx9n1G/316sRAtrYAKDNlurLjWSKVlgKrXmvQGFoGdOYvQCg4oyr
kXpfpxu6krgR4uv6SEFU6j8=
=rgM8
-----END PGP SIGNATURE-----

--nextPart8808566.2XYBIHHnaF--
