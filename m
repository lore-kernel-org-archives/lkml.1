Return-Path: <linux-kernel-owner+w=401wt.eu-S1763014AbXKMVnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014AbXKMVnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbXKMVnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:43:35 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41648 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365AbXKMVne (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:43:34 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-11-13-04-14.tar.gz uploaded
In-Reply-To: Your message of "Tue, 13 Nov 2007 19:42:10 +0300."
             <200711131942.10195.a1426z@gawab.com>
From: Valdis.Kletnieks@vt.edu
References: <200711131821.54056.a1426z@gawab.com> <1194967563.8255.20.camel@twins>
            <200711131942.10195.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1194990201_3241P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Nov 2007 16:43:21 -0500
Message-ID: <5021.1194990201@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1194990201_3241P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 Nov 2007 19:42:10 +0300, Al Boldi said:

> Oh.  What about breaking out a stable-mm snapshot against the latest stable 
> kernel?

You can roll your own of those.

Get a 2.6.23.N kernel tarball.
patch -R the 23.N patch against that, giving you a 23.0 tree.
Apply patch-2.6.24-rc2 to that.

Now apply the snapshot.

--==_Exmh_1194990201_3241P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHOhp5cC3lWbTT17ARAsOUAJ9SJWwZVIu1XOixPYmeBUsrHnxfLQCg+qfI
Wns3mgoLhbGnVz2CUCD9fyg=
=oLpH
-----END PGP SIGNATURE-----

--==_Exmh_1194990201_3241P--
