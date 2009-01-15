Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbZAOMgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbZAOMgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759712AbZAOMgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:36:18 -0500
Received: from lug-owl.de ([195.71.106.12]:37431 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759280AbZAOMgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:36:16 -0500
Date: Thu, 15 Jan 2009 13:36:14 +0100
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is 386 processor still supported?
Message-ID: <20090115123614.GR11087@lug-owl.de>
Mail-Followup-To: "Maciej W. Rozycki" <macro@linux-mips.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Jiri Kosina <jkosina@suse.cz>, Adam Osuchowski <adwol@zonk.pl>,
	linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <20090108120338.6b8b4567@zonk.pl> <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz> <1231424025.11687.447.camel@twins> <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz> <1231424833.11687.452.camel@twins> <20090108150448.2393aeb0@lxorguk.ukuu.org.uk> <20090108151046.GK18120@elte.hu> <alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="thbZYyT/l9NtheWI"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org>
X-Operating-System: Linux mail 2.6.18-5-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-message-flag: Please send plain text messages only. Do not send HTML emails. Thank you. 
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--thbZYyT/l9NtheWI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 01:06:55 +0000, Maciej W. Rozycki <macro@linux-mips.org>=
 wrote:
>=20
>  Myself, I could not resist trying an APIC-based 486 SMP box and possibly=
=20
> fixing issues if I found one and it was MPS-compliant, but nothing beyond=
=20
> that I would say.  Life's too short.

While it is not SMP, I still have one or two working i386 (and
a compatible AMD) system around.

Back in the days where I ran them the last time, there were two
issues:

  * Debian's baseline libc is compiled to use LOCK and some other
    newish instructions that are not available on a real i386 CPU.
  * There was a patch flying around to introduce a kernel-based
    emulator for those instructions. However, this was (at that time)
    neither included in Debian's kernel, nor in the upstream sources.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:               http://www.eyrie.org/~eagle/faqs/questions.html
the second  :

--thbZYyT/l9NtheWI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJby2+Hb1edYOZ4bsRApAnAKCFZ1/s5eX01Bci+aqPd9yKPVsnfwCdHHWH
l8+H50Bov5lmatsYIF15AZs=
=U10Q
-----END PGP SIGNATURE-----

--thbZYyT/l9NtheWI--
