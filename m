Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbXIXQIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbXIXQIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbXIXQIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:08:41 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48604 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbXIXQIk (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:08:40 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1 - 'touch' command causes Oops.
In-Reply-To: Your message of "Mon, 24 Sep 2007 08:45:32 PDT."
             <1190648733.26982.227.camel@localhost>
From: Valdis.Kletnieks@vt.edu
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <3339.1190630150@turing-police.cc.vt.edu> <20070924120508.GA15648@infradead.org> <3982.1190638701@turing-police.cc.vt.edu>
            <1190648733.26982.227.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190650097_3721P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Sep 2007 12:08:17 -0400
Message-ID: <14164.1190650097@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190650097_3721P
Content-Type: text/plain; charset=us-ascii

On Mon, 24 Sep 2007 08:45:32 PDT, Dave Hansen said:

> Any idea which fs and distro this was?  I'd like to add it to my tests.

initscripts-8.56-1, from Fedora Rawhide, /etc/rc.sysinit, line 325:

touch /dev/.in_sysinit >/dev/null 2>&1

Specific enough? :)

--==_Exmh_1190650097_3721P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG9+DxcC3lWbTT17ARAghwAJ9thfkFmCYdjwAuaiHmEpsgi8XWJwCg9Zcf
z+XvTpLsZFVImEUa20BDyN0=
=3hCu
-----END PGP SIGNATURE-----

--==_Exmh_1190650097_3721P--
