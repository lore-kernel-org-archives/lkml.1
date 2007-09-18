Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbXIRWDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbXIRWDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbXIRWDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:03:33 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39983 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbXIRWDd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:03:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1 - Mostly working, with a kbuild oddity
In-Reply-To: Your message of "Tue, 18 Sep 2007 22:32:39 +0200."
             <20070918203239.GB27836@uranus.ravnborg.org>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <7319.1190143977@turing-police.cc.vt.edu>
            <20070918203239.GB27836@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190153008_4811P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Sep 2007 18:03:28 -0400
Message-ID: <15592.1190153008@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190153008_4811P
Content-Type: text/plain; charset=us-ascii

On Tue, 18 Sep 2007 22:32:39 +0200, Sam Ravnborg said:

> So the external module were fiddeling with CFLAGS which is wrong.
> Yes - it worked before by accident.

OK, I can deal with that diagnosis. ;)

> Pelase ask the author of the module to either fix it or even better
> submit the driver for inclusion because then we will find it during
> the review pahse.

I'll take it up with the author, and see what happens...

> But anyway - thanks for reporting an issue related to an external module.

I had a few issues with some other modules, but they're evil binaries so
I'm taking those up directly with the companies involved.. ;)


--==_Exmh_1190153008_4811P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8EswcC3lWbTT17ARAuZbAKCxTYV6bnI+D89e+gJiZfXzReMHZgCeN7FL
OWfh7P4Xr4IP/O9ef+h0/IE=
=hg2o
-----END PGP SIGNATURE-----

--==_Exmh_1190153008_4811P--
