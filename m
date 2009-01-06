Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbZAFDxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbZAFDxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 22:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZAFDxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 22:53:25 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33908 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZAFDxY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 22:53:24 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Newall <davidn@davidnewall.com>
Cc: Kyle Moffett <kyle@moffetthome.net>, Ben Goodger <goodgerster@gmail.com>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
In-Reply-To: Your message of "Mon, 05 Jan 2009 10:38:48 +1030."
             <49614F90.2020904@davidnewall.com>
From: Valdis.Kletnieks@vt.edu
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca> <495F0672.6020708@davidnewall.com> <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com> <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com> <122713.1231068940@turing-police.cc.vt.edu>
            <49614F90.2020904@davidnewall.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231213985_3204P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Jan 2009 22:53:05 -0500
Message-ID: <42550.1231213985@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231213985_3204P
Content-Type: text/plain; charset=us-ascii

On Mon, 05 Jan 2009 10:38:48 +1030, David Newall said:
> Valdis.Kletnieks@vt.edu wrote:
> > Something to keep in mind is that the Posix standard does *NOT* say anything
> > about leap seconds - poke around in a 'struct tm' sometime.

> I have poked, decades ago.  There's nothing in struct tm that's a problem.

More correctly: "There's nothing in struct time - that's the problem."

--==_Exmh_1231213985_3204P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJYtWhcC3lWbTT17ARAsoaAKDuP/uayvm6CsHkQ4ZJkYpA4l9bsACeJwnL
6Tv4mBvCmx0Jkxc6pp4U4Ws=
=RCyD
-----END PGP SIGNATURE-----

--==_Exmh_1231213985_3204P--
