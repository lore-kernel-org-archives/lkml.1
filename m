Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbYE3Jaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbYE3Jaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYE3JaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:30:14 -0400
Received: from mail.anarazel.de ([217.115.131.40]:43805 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYE3JaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:30:13 -0400
From: Andres Freund <andres@anarazel.de>
To: Florian Attenberger <valdyn@valdyn.org>
Subject: Re: [Solved][BUG] Barely understandeable sound with snd_hda_intel and 2.6.26-rc4
Date: Fri, 30 May 2008 11:29:58 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, perex@perex.cz, tiwai@suse.de,
       pshou@realtek.com.tw, Jeff Garzik <jgarzik@redhat.com>
References: <200805300004.16169.andres@anarazel.de> <20080530072049.e260432c.valdyn@valdyn.org>
In-Reply-To: <20080530072049.e260432c.valdyn@valdyn.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2298652.LyVu6HzR5T";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805301130.03417.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2298652.LyVu6HzR5T
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Friday 30 May 2008, Florian Attenberger wrote in "Re: [BUG] Barely=20
understandeable sound with snd_hda_intel and 2.6.26-rc4":
> > CONFIG_SND_PCSP=3Dm
> ^^ is making your pc speaker your default sound device, i guess. Module
> is 'snd_pcsp'.
Ah. Sorry for not having noticed that myself...
I tried manually reinserting snd_pcsp after snd_hda_intel but obviously hda=
 is=20
the first device in this case...

Thanks,

Andres

--nextPart2298652.LyVu6HzR5T
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIP8kbporPraT14igRAlrDAJ9hZA5Tr53sZMqcof3kP9MvTvQKTQCeMZHx
/a2O1ybk5Y1t0cv0DM3/zuQ=
=TIX2
-----END PGP SIGNATURE-----

--nextPart2298652.LyVu6HzR5T--
