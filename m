Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYHYXqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYHYXqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 19:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYHYXqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 19:46:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50027 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbYHYXqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 19:46:38 -0400
Date: Tue, 26 Aug 2008 09:46:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: objcopy version test for local symbols
Message-Id: <20080826094627.5d627b5b.sfr@canb.auug.org.au>
In-Reply-To: <20080825190103.GA24029@elte.hu>
References: <20080825130117.33fe34bc.sfr@canb.auug.org.au>
	<20080825060934.GB14993@elte.hu>
	<alpine.DEB.1.10.0808251434000.23923@gandalf.stny.rr.com>
	<20080825190103.GA24029@elte.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Aug_2008_09_46_27_+1000_cIQphMTyOYX8KS.S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Aug_2008_09_46_27_+1000_cIQphMTyOYX8KS.S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo, Steve,

On Mon, 25 Aug 2008 21:01:03 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> applied to tip/tracing/ftrace, also have integrated it into=20
> auto-ftrace-next. (without much testing - i hope it goes well)

Looks ok at a first glance, but it may spam my build logs a bit ...
Anyway, we will see.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__26_Aug_2008_09_46_27_+1000_cIQphMTyOYX8KS.S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkizRFMACgkQjjKRsyhoI8wOLwCfZMFPotqn2HiigOQ3okDjoT9A
WOkAn22PhBVC95ieEgImJeecuPnYloHw
=CAcl
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Aug_2008_09_46_27_+1000_cIQphMTyOYX8KS.S--
