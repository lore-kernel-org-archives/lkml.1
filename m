Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZDPPTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZDPPTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbZDPPTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:19:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34320 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbZDPPTg (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:19:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tilman Schmidt <tilman@imap.cc>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fast testing
In-Reply-To: Your message of "Wed, 15 Apr 2009 14:45:13 +0200."
             <49E5D6D9.3040903@imap.cc>
From: Valdis.Kletnieks@vt.edu
References: <49E5D0C1.6010608@wpkg.org>
            <49E5D6D9.3040903@imap.cc>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1239895173_6564P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Apr 2009 11:19:33 -0400
Message-ID: <23524.1239895173@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1239895173_6564P
Content-Type: text/plain; charset=us-ascii

On Wed, 15 Apr 2009 14:45:13 +0200, Tilman Schmidt said:
> > Something's wrong with your setup (unless you start really lots of=
> > things or have some other, "uncommon" things).
> 
> Hmm, it's always been like that. As for "uncommon", this is a more
> or less out of the box openSUSE 10.3 installation. (Without Beagle,
> in case you were wondering.) Perhaps that's what's wrong? :-)

Umm... shot in the dark - memory incorrectly flagged as non-cachable
by an mtrr?

--==_Exmh_1239895173_6564P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ50yFcC3lWbTT17ARAgKcAKCaSYUBwH9cdBB2/Zy7u1LS0KXX6gCgnvC9
fCIrouAi6ho0Blxy/WHQn1E=
=tYBK
-----END PGP SIGNATURE-----

--==_Exmh_1239895173_6564P--
