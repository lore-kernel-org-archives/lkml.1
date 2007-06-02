Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbXFBBg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbXFBBg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbXFBBgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:36:20 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:53714 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbXFBBgU (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:36:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Scott Preece <sepreece@gmail.com>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
In-Reply-To: Your message of "Sat, 02 Jun 2007 00:10:46 +0200."
             <m3fy5b5nrt.fsf@maximus.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net> <28278.1180675923@turing-police.cc.vt.edu> <465FB862.207@zytor.com> <alpine.DEB.0.99.0706010648030.9768@sigma.j-a-k-j.com> <m3sl9b5vcm.fsf@maximus.localdomain> <7b69d1470706011237j50f29e4ch73f86acdc294fecd@mail.gmail.com>
            <m3fy5b5nrt.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180748167_4213P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Jun 2007 21:36:07 -0400
Message-ID: <8127.1180748167@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180748167_4213P
Content-Type: text/plain; charset=us-ascii

On Sat, 02 Jun 2007 00:10:46 +0200, Krzysztof Halasa said:
> "Scott Preece" <sepreece@gmail.com> writes:
> 
> > This is a question worth answering - is it rude to ack/nak a patch if
> > you're not a maintainer or otherwise known-to-be-trusted, or is it OK
> > for anyone to express an opinion? Andrew's patch text seems to imply
> > that it's generally OK.
> 
> Every pair of eyes (or a single one) looking at the patch in question
> is a good thing. I can't imagine why would one want to look at the
> code if he/she can't ack or nak or otherwise comment it.

I'd be the *first* to admit that my kernel-foo isn't perfect, and sometimes I'm
right and sometimes I'm wrong when I review somebody else's code.  I certainly
*hope* that nobody's taking my review as anything more authoritative than "an
actual maintainer might want to look at this".

On the other hand, we don't need a Foo-By: tag for "or otherwise comment".

Phrased differently, if I haven't stuck a "Signed-off-by:" or "Tested-By:"
on it, I'm by default only commenting.  The code submitter can decide I'm right
and fix and resubmit, the maintainer can decide I'm right and toss a NAK. Or
they can both decide I'm full of it and hit the Delete key..

--==_Exmh_1180748167_4213P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGYMmHcC3lWbTT17ARAnT5AJ9vSkFSYQM1qpi7NMEHoC3OfpjaawCg7xOj
nec/fGYmsNO1+7PGiF8op4Y=
=v5jG
-----END PGP SIGNATURE-----

--==_Exmh_1180748167_4213P--
