Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZAFSmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZAFSmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZAFSmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:42:14 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56489 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZAFSmN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:42:13 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MCE error log
In-Reply-To: Your message of "Tue, 06 Jan 2009 14:00:03 +0100."
             <c4e36d110901060500w289708d5ne252ace7a2fd9944@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <c4e36d110901060500w289708d5ne252ace7a2fd9944@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231267329_4037P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Jan 2009 13:42:09 -0500
Message-ID: <20656.1231267329@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231267329_4037P
Content-Type: text/plain; charset=us-ascii

On Tue, 06 Jan 2009 14:00:03 +0100, Zdenek Kabelac said:

> CPU 1 BANK 128 TSC 57976afd

> I could only see  bank0ctl ... bank5ctl - so where is bank 128 ?

I've had bank 128 reported before. Turned out it was for thermal events caused
by dust bunnies clogging a cooling vent.  I never did find an official
statement that's what 128 is for, but I did find a bunch of hints....

What does lm_sensors say the CPU temp is sitting at?


--==_Exmh_1231267329_4037P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJY6YBcC3lWbTT17ARArdeAJ9uLCN0B+wBAWbKOZmptkbnXBaL9ACghK6i
3FP+9f8MO9+NTIZv9FZRR3E=
=cwCo
-----END PGP SIGNATURE-----

--==_Exmh_1231267329_4037P--
