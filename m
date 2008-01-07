Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYAGRce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYAGRce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbYAGRc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:32:27 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54701 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbYAGRc0 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:32:26 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Woodhouse <dwmw2@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com, olof@lixom.net,
       mingo@elte.hu, mpm@selenic.com
Subject: Re: [patch 3/5] Add the end-of-trace marker and the module list to WARN_ON()
In-Reply-To: Your message of "Sun, 06 Jan 2008 10:04:06 GMT."
             <1199613846.4111.325.camel@shinybook.infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <20080105190713.73745ec6@laptopd505.fenrus.org> <20080105191044.23712dc7@laptopd505.fenrus.org>
            <1199613846.4111.325.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199727066_2703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Jan 2008 12:31:06 -0500
Message-ID: <8221.1199727066@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199727066_2703P
Content-Type: text/plain; charset=us-ascii

On Sun, 06 Jan 2008 10:04:06 GMT, David Woodhouse said:
> 
> On Sat, 2008-01-05 at 19:10 -0800, Arjan van de Ven wrote:
> > Another issue is that, unlike oopses, WARN_ON() doesn't currently
> > printk the helpful "cut here" line, 
> 
> I'd rather see the 'cut here' line disappear altogether. Often, the
> line(s) which come immediately before it are extremely relevant to the
> problem. Cutting them is bad.

How about "--- cut 10 lines above this line ---"?

--==_Exmh_1199727066_2703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHgmHacC3lWbTT17ARAkRbAKDB2D7GDubzYoZxttDLIcI+D6OzqACfXDwS
L+AP+g+cg9cbymqiF+YyDxw=
=Lk7C
-----END PGP SIGNATURE-----

--==_Exmh_1199727066_2703P--
