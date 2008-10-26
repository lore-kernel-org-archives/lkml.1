Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYJZLbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYJZLbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYJZLbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:31:07 -0400
Received: from mail.anarazel.de ([217.115.131.40]:48089 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbYJZLbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:31:06 -0400
From: Andres Freund <andres@anarazel.de>
To: "Mikko C." <mikko.cal@gmail.com>
Subject: Re: Random problems with 2.6.28-rc1-git1
Date: Sun, 26 Oct 2008 12:30:56 +0100
User-Agent: KMail/1.10.1 (Linux/2.6.27-andres-05577-g0cfd810; KDE/4.1.2; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
References: <490332E5.3020108@gmail.com> <Pine.LNX.4.64.0810260235490.22126@twin.jikos.cz> <49041B73.8060603@gmail.com>
In-Reply-To: <49041B73.8060603@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1389617.TBvnFh9mok";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810261231.02764.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1389617.TBvnFh9mok
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Sunday 26 October 2008 08:25:39 Mikko C. wrote:
> > If rmmod never returns, alt-sysrq-t output should show us where it got
> > stuck.
> Thanks for your answer
> I tried Alt-Sysrq-T after a rmmod, but all I get is:
> "SysRq : Show State"
> Is it normal? Does it dump the information to a log?
> Sorry but I never used sysrq in the past.
You propably have to set the loglevel to something higher before. Either us=
e=20
dmesg -n 6 or so or sysrq-6.

Andres

--nextPart1389617.TBvnFh9mok
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkEVPEACgkQporPraT14ihx1QCdFkN8n0exUAPRwm6Oru/c+dY5
rNkAnijsu092879PPgKM3AssFeF1pcV5
=6cmx
-----END PGP SIGNATURE-----

--nextPart1389617.TBvnFh9mok--
