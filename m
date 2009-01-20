Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZATDcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZATDcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 22:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbZATDcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 22:32:35 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39026 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZATDce (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 22:32:34 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Diego Calleja <diegocg@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Faulty seagate drives, are going to be blacklisted?
In-Reply-To: Your message of "Tue, 20 Jan 2009 00:29:23 +0100."
             <20090120002923.065f24ca@diego-desktop>
From: Valdis.Kletnieks@vt.edu
References: <20090120002923.065f24ca@diego-desktop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1232422345_3870P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Jan 2009 22:32:25 -0500
Message-ID: <85346.1232422345@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1232422345_3870P
Content-Type: text/plain; charset=us-ascii

On Tue, 20 Jan 2009 00:29:23 +0100, Diego Calleja said:
> Tech sites are reporting everywhere a massive flaw in seagate drives that
> can lock up the drive and make it unusable (the bios doesn't detect it, you
> can't read the data). Haven't read anything about it here on the lists.
> Seagate has ack'ed the problem:
> http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207931
> 
> So, apparently there're a lot of drives on the market (including mine)
> that can die any day. Are those drives going to be blacklisted?

The $64 question is, of course: What exactly should the operating system
*do* if it detects one of these drives?  Prohibit it from bricking later
by essentially bricking it *now*?   What if the drive already has a lot of
production data on it?


--==_Exmh_1232422345_3870P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJdUXJcC3lWbTT17ARAgSBAJ9lYdzmH4bNILEuzidr5rpMZsT+PACg81mX
pZh6YQzWDxeyMx6UWTgHzoY=
=LQ4L
-----END PGP SIGNATURE-----

--==_Exmh_1232422345_3870P--
