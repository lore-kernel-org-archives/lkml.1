Return-Path: <linux-kernel-owner+w=401wt.eu-S935591AbXGLVcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935591AbXGLVcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 17:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbXGLVcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 17:32:10 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:37071 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757843AbXGLVcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 17:32:08 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: v2.6.22.1-rt1
Date: Thu, 12 Jul 2007 23:31:52 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070712121355.GA10949@elte.hu> <200707121645.46206.mgd@technosis.de> <20070712160139.GB8252@elte.hu>
In-Reply-To: <20070712160139.GB8252@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1240844.KQ6A0WQCvD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707122332.04193.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1184275928;bb3c151d;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1240844.KQ6A0WQCvD
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> > > to build a 2.6.22.1-rt1 tree, the following patches should be applied:
> > > =A0
> > > =A0 =A0http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2
> > > =A0 =A0http://redhat.com/~mingo/realtime-preempt/patch-2.6.22.1-rt1
> >=20
> > I get a compile error on my x86_64 dualcore sytem.
>=20
> could you check it builds fine with -rt2?

It builds fine now with -rt2.

Thanks, best wishes,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1240844.KQ6A0WQCvD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGlp3UUYYhyuxDQc4RArnNAJ96App9OeaOrW7i6SmCo/qF5fjGDACgjVis
v+7dIJDSH6aTjGz5qsEva40=
=zQWo
-----END PGP SIGNATURE-----

--nextPart1240844.KQ6A0WQCvD--
