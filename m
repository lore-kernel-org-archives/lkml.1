Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbZAFFVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbZAFFVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 00:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbZAFFVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 00:21:15 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59369 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZAFFVO (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 00:21:14 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-mmotm1230 - BUG during 'shutdown -h'
In-Reply-To: Your message of "Mon, 05 Jan 2009 16:36:12 +1030."
             <200901051636.12708.rusty@rustcorp.com.au>
From: Valdis.Kletnieks@vt.edu
References: <4491.1230900738@turing-police.cc.vt.edu> <200901031743.35578.rusty@rustcorp.com.au> <3543.1231000591@turing-police.cc.vt.edu>
            <200901051636.12708.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231219264_3003P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Jan 2009 00:21:04 -0500
Message-ID: <3086.1231219264@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231219264_3003P
Content-Type: text/plain; charset=us-ascii

On Mon, 05 Jan 2009 16:36:12 +1030, Rusty Russell said:

> Linus has just merged the cpumask tree, so if it did cause this problem,
> Linus' tree should show it.

For what it's worth, I just build 28-mmotm0105, and 'shutdown -h' now
shuts the machine down cleanly.  So I'm concluding that somebody's change
between -1230 and -0105 fixed the issue.

--==_Exmh_1231219264_3003P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJYupAcC3lWbTT17ARAtUnAKDjBGWuUpDP1AdcMN+c1psiAjAIHwCcDkhy
f93rOzkRT24O3m6AYwXBbkg=
=TekQ
-----END PGP SIGNATURE-----

--==_Exmh_1231219264_3003P--
