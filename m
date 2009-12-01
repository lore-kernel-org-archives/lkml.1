Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZLALTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZLALTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 06:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZLALT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 06:19:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35199 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZLALT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 06:19:28 -0500
Date: Tue, 1 Dec 2009 22:19:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 1
Message-Id: <20091201221924.48b5a988.sfr@canb.auug.org.au>
In-Reply-To: <s5h8wdn0yal.wl%tiwai@suse.de>
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
	<20091201102900.GA11715@sirena.org.uk>
	<s5h8wdn0yal.wl%tiwai@suse.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Dec_2009_22_19_24_+1100_dUJKF=1p1.BydaSe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Dec_2009_22_19_24_+1100_dUJKF=1p1.BydaSe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

On Tue, 01 Dec 2009 11:43:46 +0100 Takashi Iwai <tiwai@suse.de> wrote:
>
> Stephen, please drop that specific patch from your tree (if it's really
> applied).  It's been already in sound git tree, so the build should be
> OK now without it.

Yeah, that is what I missed yesterday.  I will not try to apply it
tomorrow so everything should be well again.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Dec_2009_22_19_24_+1100_dUJKF=1p1.BydaSe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksU+7wACgkQjjKRsyhoI8wTTQCfWCjCQ77T5xtUF499AQHNDBdT
cKMAniRss3Vw2vLTWScTphsOuf6TnX4W
=+877
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Dec_2009_22_19_24_+1100_dUJKF=1p1.BydaSe--
