Return-Path: <linux-kernel-owner+w=401wt.eu-S1762649AbXFBTfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762649AbXFBTfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760359AbXFBTfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:35:06 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:39183 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174AbXFBTfE (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:35:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: debian developer <debiandev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Scott Preece <sepreece@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
In-Reply-To: Your message of "Sat, 02 Jun 2007 19:04:29 +0530."
             <f24d23310706020634p3f9f4187j577bea46df86ee5d@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net> <28278.1180675923@turing-police.cc.vt.edu> <465FB862.207@zytor.com> <alpine.DEB.0.99.0706010648030.9768@sigma.j-a-k-j.com> <m3sl9b5vcm.fsf@maximus.localdomain> <7b69d1470706011237j50f29e4ch73f86acdc294fecd@mail.gmail.com> <20070601130024.72163dc0.akpm@linux-foundation.org> <20070601130411.218009d5.akpm@linux-foundation.org>
            <f24d23310706020634p3f9f4187j577bea46df86ee5d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180812889_4213P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 02 Jun 2007 15:34:49 -0400
Message-ID: <7064.1180812889@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180812889_4213P
Content-Type: text/plain; charset=us-ascii

On Sat, 02 Jun 2007 19:04:29 +0530, debian developer said:
> On 6/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > It's quite common for experienced kernel developers to ack completely broken
> > patches.
> 
> common!!
> 
> is'nt that a bit too ...

Lots of code looks totally reasonable to a kernel coder, except it doesn't
actually work when run, or doesn't actually build for a common architecture.
Let's face it - if I hit a bug on my Dell Latitude in a -mm kernel, our
current depth of testers means that I'm probably the only person who's
likely to test the fix before it goes uptream to Linus as a "probably works".


--==_Exmh_1180812889_4213P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGYcZZcC3lWbTT17ARAkVtAJ4j99xpJ5jrdCBFcGERZDwSlHBI/QCfa4Re
xF0KyVhmxbx2Wckmvdjhbb8=
=p2Es
-----END PGP SIGNATURE-----

--==_Exmh_1180812889_4213P--
