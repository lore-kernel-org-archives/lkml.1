Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbYLHDrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbYLHDrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 22:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbYLHDrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 22:47:23 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54139 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbYLHDrX (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 22:47:23 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Nick Andrew <nick@nick-andrew.net>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Fix incorrect use of loose in migrate.c
In-Reply-To: Your message of "Sun, 07 Dec 2008 00:55:36 +1100."
             <20081206135536.GH5957@mail.local.tull.net>
From: Valdis.Kletnieks@vt.edu
References: <20081205030807.32309.69191.stgit@marcab.local.tull.net> <20081206121227.GA6292@wotan.suse.de>
            <20081206135536.GH5957@mail.local.tull.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1228708010_4679P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 07 Dec 2008 22:46:50 -0500
Message-ID: <36049.1228708010@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1228708010_4679P
Content-Type: text/plain; charset=us-ascii

On Sun, 07 Dec 2008 00:55:36 +1100, Nick Andrew said:
> On Sat, Dec 06, 2008 at 01:12:27PM +0100, Nick Piggin wrote:

> > I don't know... presumably we haven't just gone and lost the little
> > bugger. I mean, we were holding it one minute, then... gone?  Do we
> > have Alzheimer's? Unlikely. I think we loosed it.
> 
> Loosen?

"Cry Cheeble, and loose the hamsters of war!"

--==_Exmh_1228708010_4679P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJPJiqcC3lWbTT17ARAkQCAKCk6CgoeGgtatE27aAlWodNFWyU6ACgogcU
MBdX0wZjQEQGTHRM9HebSfM=
=5a20
-----END PGP SIGNATURE-----

--==_Exmh_1228708010_4679P--
