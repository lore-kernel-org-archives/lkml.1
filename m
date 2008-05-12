Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYELN2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYELN2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYELN2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:28:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:44291 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750761AbYELN2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:28:43 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX19R0SgnPEhR8fhkw8l4FnIDG5WrWQKa+2pJbKOM+R
	LHlQ9QMq6mkdfo
Date: Mon, 12 May 2008 15:28:34 +0200
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
Cc: Jan Engelhardt <jengelh@medozas.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Hard lockup with kernel 2.6.25 and 2.6.25.1
Message-ID: <20080512152834.37507516@highlander.home.lan>
In-Reply-To: <20080504222246.50dc6f5b@highlander.home.lan>
References: <20080504005209.13af2b2c@highlander.home.lan>
	<20080503231813.GA18248@kroah.com>
	<20080504115108.7b5a8e3f@highlander.home.lan>
	<alpine.LNX.1.10.0805042155530.11757@fbirervta.pbzchgretzou.qr>
	<20080504222246.50dc6f5b@highlander.home.lan>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ijzjfXrZAH6Fh/G2IKBmdB=";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ijzjfXrZAH6Fh/G2IKBmdB=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 4 May 2008 22:22:46 +0200
Malte Schr=C3=B6der <maltesch@gmx.de> wrote:
> Besides from that I am currently trying to find the last working
> kernel-version, since 2.6.24.6 shows the same problem.
> I am currently running 2.6.24.5 again. Let's see if that runs stable.
> When I have found a stable kernel I think I will bisect it, but I am
> quite busy currently so it could take a while. Who knows, maybe it's
> not the kernel's fault at all but some strange kind of hardware failure.

A short report to that issue:
I went back down to 2.6.24.4 and the problem did not disappear. I am
not convinced that this is a new kernel-bug.
I will investigate this more and come back if/when I find some more
clues.

Regards
--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------


--Sig_/ijzjfXrZAH6Fh/G2IKBmdB=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIKEYH4q3E2oMjYtURAl26AJ936hgfIw/Xq3VyeFXMQMsyoFMRGwCgop6/
QzqEknmhIKoHj0pKPL4csNs=
=2ziN
-----END PGP SIGNATURE-----

--Sig_/ijzjfXrZAH6Fh/G2IKBmdB=--
