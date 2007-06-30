Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbXF3ER6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbXF3ER6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 00:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbXF3ERu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 00:17:50 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43034 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXF3ERt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 00:17:49 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
In-Reply-To: Your message of "Fri, 29 Jun 2007 14:01:30 PDT."
             <20070629140130.59d58c44.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <6150.1183128630@turing-police.cc.vt.edu>
            <20070629140130.59d58c44.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1183177066_3843P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 30 Jun 2007 00:17:46 -0400
Message-ID: <15437.1183177066@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1183177066_3843P
Content-Type: text/plain; charset=us-ascii

On Fri, 29 Jun 2007 14:01:30 PDT, Andrew Morton said:
> On Fri, 29 Jun 2007 10:50:30 -0400
> Valdis.Kletnieks@vt.edu wrote:

> > Odd - just for grins, I checked what 'make oldconfig' did when handed a .config
> > from 22-rc4-mm2, and it behaved just fine, much to my surprise.
> 
> That's probably because your old config file was relatively recent, and
> had things like CONFIG_BLK_DEV=y in it.

Ahh... <light bulb goes on> Yeah, it gets a 'make oldconfig' for pretty
much every single -mm, I suck at any regression testing other than "since
the last -mm".

--==_Exmh_1183177066_3843P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGhdlqcC3lWbTT17ARAsxRAKCleBTVWbw8PbTNoISJWF1F7eQftgCg4uKR
DoJAXzKijdmbzoa7ELeg9yw=
=Zcc9
-----END PGP SIGNATURE-----

--==_Exmh_1183177066_3843P--
