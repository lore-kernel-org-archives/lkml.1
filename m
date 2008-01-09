Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYAIEV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYAIEV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYAIEVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:21:50 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50294 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYAIEVt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:21:49 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Thanasis <thanasis@asyr.hopto.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NIC as RS232
In-Reply-To: Your message of "Tue, 08 Jan 2008 08:48:35 +0200."
             <47831CC3.9080604@asyr.hopto.org>
From: Valdis.Kletnieks@vt.edu
References: <47831CC3.9080604@asyr.hopto.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199852504_3703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Jan 2008 23:21:44 -0500
Message-ID: <9263.1199852504@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199852504_3703P
Content-Type: text/plain; charset=us-ascii

On Tue, 08 Jan 2008 08:48:35 +0200, Thanasis said:

> Is there a kernel driver that would make a NIC's port work as a RS232
> port, using the serial cables that are RJ45 on one side and DB9 or DB25
> on the other? Maybe null modem cables of that type ? Or for example
> those used by cisco as console port cables?
> 
> (or may be I'm dreaming ;-)

What I *have* seen are connectors that go from DB9/25 to RJ11, not RJ45.
Basically, using the RJ11 to terminate a 4-conductor cable wired up for
serial use.  It's often hard to tell an 11 from a 45 unless you look at
it *real* close....

--==_Exmh_1199852504_3703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHhEvYcC3lWbTT17ARApMhAJ9Mc4lp+COEvbbMoE/twY2XMOyolQCg1oCG
CS9TwtWFYobCE+JIeFQbs7M=
=0k5/
-----END PGP SIGNATURE-----

--==_Exmh_1199852504_3703P--
