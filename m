Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbYGaDgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbYGaDgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbYGaDgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:36:38 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43819 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbYGaDgi (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:36:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc1 + selinux new options = no httpd
In-Reply-To: Your message of "Wed, 30 Jul 2008 22:54:25 EDT."
             <200807302254.26036.gene.heskett@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <200807302254.26036.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1217475396_3077P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 30 Jul 2008 23:36:36 -0400
Message-ID: <195215.1217475396@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1217475396_3077P
Content-Type: text/plain; charset=us-ascii

On Wed, 30 Jul 2008 22:54:25 EDT, Gene Heskett said:
> Greetings;
> 
> I just had to reboot backwards to 2.6.26 as I don't seem to be able to turn 
> off enough selinux stuff to allow apache (httpd) to run, on 2.6.27-rc1 it 
> cannot get perms to access its log files so it exits.

Oddness indeed - booting with 'permissive' should at least let things work
so you can diagnose the problem.

Do you have any of the AVC messages that got generated when apache failed?

--==_Exmh_1217475396_3077P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIkTNEcC3lWbTT17ARAqN8AJ9AYqzIc1EHtQdOyOLbwYyHzcsGxwCgu4MY
Obtvnza1yEK14H4SxJMiTYI=
=2fcb
-----END PGP SIGNATURE-----

--==_Exmh_1217475396_3077P--
