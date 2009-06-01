Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbZFAIsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbZFAIsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZFAIsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:48:21 -0400
Received: from jack.hrz.tu-chemnitz.de ([134.109.132.46]:41718 "EHLO
	jack.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZFAIsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:48:19 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: add specific support for Intel Atom architecture
Date: Mon, 1 Jun 2009 10:48:07 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-rc7; KDE/4.2.85; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <1243638699-15194-1-git-send-email-tobias.doerffel@gmail.com> <87r5y4cqub.fsf@basil.nowhere.org>
In-Reply-To: <87r5y4cqub.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1465409.HYaWQVMQMz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906011048.18305.tobias.doerffel@gmail.com>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: cb5add96829c288e5da73fa3a8e2275c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1465409.HYaWQVMQMz
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

Am Montag, 1. Juni 2009 10:15:24 schrieben Sie:
> Tobias Doerffel <tobias.doerffel@gmail.com> writes:
> > This adds another option when selecting CPU family so the kernel can
> > be optimized for Intel Atom CPUs. If GCC supports tuning options for
> > Intel Atom they will be used.
>
> You seem to have ignored the earlier review feedback?
Actually not. Both of the issues (MODULE_PROC_FAMILY, mtune=3Dgeneric) were=
=20
discussed but we didn't obtain a final agreement on them. So what do you (a=
nd=20
others) suggest?

Regards,

Toby

--nextPart1465409.HYaWQVMQMz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAkojlccACgkQHsjdpw2OaaeClwCfS7fVTPoXBBAVoO3Nuo7h53dt
txsAlRI5KR3n2zINVRlwOBmjc/O7gY0=
=rrNF
-----END PGP SIGNATURE-----

--nextPart1465409.HYaWQVMQMz--
