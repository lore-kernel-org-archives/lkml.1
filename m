Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbXJYUJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbXJYUJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762171AbXJYUJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:09:19 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35685 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762548AbXJYUJN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:09:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jeff@garzik.org>,
       Sam Ravnborg <sam@ravnborg.org>, Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] create instrumentation/ directory
In-Reply-To: Your message of "Wed, 24 Oct 2007 13:31:02 EDT."
             <20071024173102.GA29958@Krystal>
From: Valdis.Kletnieks@vt.edu
References: <20071024095226.GA30326@havoc.gtf.org> <20071024130557.GA18610@Krystal> <471F4649.3000000@garzik.org> <20071024091240.7978c2da.rdunlap@xenotime.net>
            <20071024173102.GA29958@Krystal>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1193342893_2831P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Oct 2007 16:08:13 -0400
Message-ID: <8869.1193342893@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1193342893_2831P
Content-Type: text/plain; charset=us-ascii

On Wed, 24 Oct 2007 13:31:02 EDT, Mathieu Desnoyers said:

> Therefore, we could also move the kprobes and marker samples under
> 
> instrumentation/samples/
> 
> My main concern is that 15 characters long directory name might be
> inelegant (however, it only beats Documentation by 2).

How so?  i n s esc.  4 keystrokes (and still 2 more than D<ESC> ;)


--==_Exmh_1193342893_2831P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHIPetcC3lWbTT17ARAppRAJ9IHy4ziIR7poT+kn2DvhwKUt4QrgCg8WbZ
hzbGKEEKpV+k8QKrZjnaedw=
=rA4M
-----END PGP SIGNATURE-----

--==_Exmh_1193342893_2831P--
