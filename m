Return-Path: <linux-kernel-owner+w=401wt.eu-S1031046AbXDXIl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031046AbXDXIl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031070AbXDXIl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:41:58 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:36728 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031067AbXDXIl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:41:57 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v5 vs sd-0.46
Date: Tue, 24 Apr 2007 10:41:52 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
References: <200704240938.07482.mgd@technosis.de> <200704241017.10610.mgd@technosis.de> <20070424082305.GA6332@elte.hu>
In-Reply-To: <20070424082305.GA6332@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7908758.K047btot3A";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704241041.53762.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1177404117;da159e63;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7908758.K047btot3A
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Here i'm assuming that the vmstats are directly comparable: that your=20
> number-crunchers behave the same during the full runtime - is that=20
> correct?

Yes, basically it does (disregarding small fluctuations)

I'll see whether I can produce some type of absolute performance
measure as well. Thinking about it I guess this should be fairly
simple to implement.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart7908758.K047btot3A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGLcLRUYYhyuxDQc4RAh5bAJ0cIDcO/SohmE9FLCaGvcoZXFkWEQCfaGAO
LNp1ZWJTFxTpE06/owIWfS0=
=jbRb
-----END PGP SIGNATURE-----

--nextPart7908758.K047btot3A--
