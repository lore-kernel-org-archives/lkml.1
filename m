Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYBYLCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYBYLCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYBYLCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:02:09 -0500
Received: from smtp4.int-evry.fr ([157.159.10.71]:52200 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbYBYLCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:02:08 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][x86] rdc321x: remove watchdog file
Date: Mon, 25 Feb 2008 12:02:06 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200802251144.08962.florian.fainelli@telecomint.eu> <20080225105408.GB5648@elte.hu>
In-Reply-To: <20080225105408.GB5648@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2881215.Vs7KDcfWUE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802251202.08091.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2881215.Vs7KDcfWUE
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ingo,

Le lundi 25 f=E9vrier 2008, Ingo Molnar a =E9crit=A0:
> thanks, applied. I guess i should push this change upstream only once
> the new watchdog driver has been committed to drivers/watchdog/ ?

Yes it would be better, thank you very much !

--nextPart2881215.Vs7KDcfWUE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHwqAvmx9n1G/316sRArDnAJ4zFAXbW9Ribfl/l1+ABKVB9WZnnwCfcsxV
P5u0zw/+dHKPk6+MLC5G5rA=
=V6aP
-----END PGP SIGNATURE-----

--nextPart2881215.Vs7KDcfWUE--
