Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbXK0Iqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbXK0Iqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 03:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbXK0Iqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 03:46:40 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49373 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXK0Iqj (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 03:46:39 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1 - brick my Dell Latitude D820
In-Reply-To: Your message of "Tue, 27 Nov 2007 16:25:22 +0800."
             <a8e1da0711270025v4c6c04b6gf8d5916670f5efa6@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4210.1196147786@turing-police.cc.vt.edu>
            <a8e1da0711270025v4c6c04b6gf8d5916670f5efa6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196153194_2790P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Nov 2007 03:46:34 -0500
Message-ID: <9301.1196153194@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196153194_2790P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Nov 2007 16:25:22 +0800, Dave Young said:

> does boot_delay helps?

It might, if the kernel lived long enough to output a first printk for
us to delay after.  :)

Shooting this one would be *easy* if the problem was an boot-time oops that
would otherwise scroll off the screen without a boot_delay...

--==_Exmh_1196153194_2790P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHS9lqcC3lWbTT17ARAoTCAJ44KFuctXkqY6j9q1olxD4ICijbSACcCbIb
CsBxksWMmjuZlgWWJICgsoM=
=aUSZ
-----END PGP SIGNATURE-----

--==_Exmh_1196153194_2790P--
