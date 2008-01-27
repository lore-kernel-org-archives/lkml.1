Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYA0WF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYA0WF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYA0WFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:05:15 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:14018 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbYA0WFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:05:13 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <86802c440801261659s1102f38cr16858d350929b0e1@mail.gmail.com>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
	 <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>
	 <86802c440801261659s1102f38cr16858d350929b0e1@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HemCLhWhS8Sq5A4IF7BP"
Date: Sun, 27 Jan 2008 22:04:59 +0000
Message-Id: <1201471499.18241.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 3/9] x86_64: Switch to .data.compressed in
	arch/x86/boot/compressed/vmlinux_64.scr
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HemCLhWhS8Sq5A4IF7BP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-01-26 at 16:59 -0800, Yinghai Lu wrote:

> can you make 32 bit use .text.compressed instead ?

Any reason to prefer .text? It is data at this stage after all.

Ian.

--=20
Ian Campbell

Justice always prevails ... three times out of seven!
		-- Michael J. Wagner

--=-HemCLhWhS8Sq5A4IF7BP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHnQALM0+0qS9rzVkRAiRBAJ91YtO3bSVSTQKS7fP6YbIWVNktNACeMmbe
B3o4C28xkuf1r+OL5RQ8S2I=
=2Lrt
-----END PGP SIGNATURE-----

--=-HemCLhWhS8Sq5A4IF7BP--

