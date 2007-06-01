Return-Path: <linux-kernel-owner+w=401wt.eu-S1762167AbXFAR1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762167AbXFAR1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbXFAR1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:27:30 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46638 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760572AbXFAR13 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:27:29 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
In-Reply-To: Your message of "Thu, 31 May 2007 23:10:42 PDT."
             <465FB862.207@zytor.com>
From: Valdis.Kletnieks@vt.edu
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net> <28278.1180675923@turing-police.cc.vt.edu>
            <465FB862.207@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180718845_9513P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Jun 2007 13:27:25 -0400
Message-ID: <11341.1180718845@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180718845_9513P
Content-Type: text/plain; charset=us-ascii

On Thu, 31 May 2007 23:10:42 PDT, "H. Peter Anvin" said:
> Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 31 May 2007 19:09:10 PDT, akpm@linux-foundation.org said:
> > 
> >> +If a person was not directly involved in the preparation or handling of a
> >> +patch but wishes to signify and record their approval of it then they can
> >> +arrange to have an Acked-by: line added to the patch's changelog.
> >> +
> >> +Acked-by: is often used by the maintainer of the affected code when that
> >> +maintainer neither wrote, merged nor forwarded the patch themselves.
> > 
> > Do we want to add verbiage saying that an Acked-By: is also useful when it
> > comes from somebody (likely the original reporter) who has actually tested the
> > patch?
> 
> I'd rather see a Tested-By: for that.
> 
> There is a difference between a maintainer ack and a tester ok.

OK by me.  Half the time when a -mm breaks for me, it's an obvious one-liner
I can S-o-b: myself, the other half the time somebody else has a fix that
I keep thinking I should stick *something* on once I confirm it's fixed.

Do Linus/Andrew/major maintainers want Tested-By:'s for patches?


--==_Exmh_1180718845_9513P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGYFb9cC3lWbTT17ARAqZaAKC5zRlcC0vVKuMjSA9J6Q6K6UTTDgCgiEMh
DcY1RAOcTK7Xf3xd63/IMOY=
=S7F1
-----END PGP SIGNATURE-----

--==_Exmh_1180718845_9513P--
