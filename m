Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZHTNeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZHTNeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZHTNeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:34:07 -0400
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:52047 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754389AbZHTNeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:34:06 -0400
X-Greylist: delayed 3608 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2009 09:34:06 EDT
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Atom processor inclusion
Date: Thu, 20 Aug 2009 14:33:49 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6; KDE/4.3.0; i686; ; )
Cc: Kelly Bowa <kelly.bowa@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090820130648.6e7236f7@titus> <20090820105029.GF29093@elte.hu>
In-Reply-To: <20090820105029.GF29093@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3922912.Im7xykW4K4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200908201433.54785.tobias.doerffel@gmail.com>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 1eda448be3d4df409c597eaefe2c9e50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3922912.Im7xykW4K4
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

Am Donnerstag, 20. August 2009 12:50:29 schrieb Ingo Molnar:
> Yep, it looked acceptable - Tobias, do you have any
> updates / latest version of that patch?
No - it's still the improved version I posted at the end of May [1]. The=20
question is what to do with MODULE_PROC_FAMILY (CORE2 or ATOM) and the mtun=
e-
fallback (generic, i686, ...)?

Regards,

Tobias


[1] http://lkml.org/lkml/2009/5/29/374

--nextPart3922912.Im7xykW4K4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqNQq4ACgkQHsjdpw2OaacOdwCgrYKxZMSxi6ATHmau8ETKO207
RNsAnimvb5eUGFRhOE98GKdSf8MG21qL
=ffhw
-----END PGP SIGNATURE-----

--nextPart3922912.Im7xykW4K4--
