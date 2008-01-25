Return-Path: <linux-kernel-owner+w=401wt.eu-S933098AbYAYImr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbYAYImr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764440AbYAYIDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:03:54 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41356 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761068AbYAYIDx (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:03:53 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] Linux Kernel Markers Support for Proprierary Modules
In-Reply-To: Your message of "Fri, 25 Jan 2008 08:56:09 +0100."
             <Pine.LNX.4.64.0801250840340.12676@fbirervta.pbzchgretzou.qr>
From: Valdis.Kletnieks@vt.edu
References: <1201029235.18144.62.camel@perihelion> <y0modbdnt4e.fsf@ton.toronto.redhat.com> <20080123031005.GA16766@Krystal> <1201061860.25284.28.camel@perihelion> <20080123131442.GA6562@redhat.com> <20080123144811.GA12296@Krystal> <27267.1201152358@turing-police.cc.vt.edu> <1201155569.25284.88.camel@perihelion> <20080124124703.GB32559@Krystal>
            <Pine.LNX.4.64.0801250840340.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201248183_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 03:03:03 -0500
Message-ID: <15663.1201248183@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201248183_2846P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Jan 2008 08:56:09 +0100, Jan Engelhardt said:
> So what is needed is an Oops with an explaining message
> if (kernel_tainted) "blame that proprietary module first",
> and make sure the user sees that oops even if in X.

The person who solves the "even if in X" problem will probably be nominated
for sainthood by the Linux community.  "It just hung with flashing LED's" is
just too common an event....


--==_Exmh_1201248183_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmZe3cC3lWbTT17ARApK2AKDOKz5S19PFIhhQDpUNXkeLKPlRWACbBtTI
K8f08QWNf0DnlJHBNwfVXsw=
=Kw3l
-----END PGP SIGNATURE-----

--==_Exmh_1201248183_2846P--
