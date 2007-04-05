Return-Path: <linux-kernel-owner+w=401wt.eu-S1767394AbXDEWrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767394AbXDEWrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767399AbXDEWrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:47:49 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53208 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767394AbXDEWrs (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:47:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Bill Davidsen <davidsen@tmr.com>
Cc: Mockern@yandex.ru, linux-kernel@vger.kernel.org
Subject: Re: Question: half-duplex and full-duplex serial driver
In-Reply-To: Your message of "Thu, 05 Apr 2007 18:40:55 EDT."
             <46157AF7.1070906@tmr.com>
From: Valdis.Kletnieks@vt.edu
References: <4607D065.000004.05517@ariel.yandex.ru>
            <46157AF7.1070906@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175813262_18759P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 05 Apr 2007 18:47:42 -0400
Message-ID: <1818.1175813262@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175813262_18759P
Content-Type: text/plain; charset=us-ascii

On Thu, 05 Apr 2007 18:40:55 EDT, Bill Davidsen said:
> Mockern wrote:
> > Hi,
> > 
> > Could you help me please, how can my serial driver to work in  half-duplex and full-duplex mode?
> > 
> > Thank you
> 
> Since you don't seem to have gotten an answer, and while this is 
> probably the wrong list for your question, I can give you a pointer 
> which may help.

I got the impression that they were trying to write an in-kernel driver for
a serial card, and it was oopsing.  My first guess is "bad locking",
and my first suggestion is 'Linux Device Drivers, 3rd edition'

http://lwn.net/Kernel/LDD3 last I remember.

--==_Exmh_1175813262_18759P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGFXyOcC3lWbTT17ARAqnIAKCIjUALW3d4ZOS7OaMOhNb3QPwNOwCg+EWU
ROpGbhcQR8hEV+DnMpkpjFk=
=gYZ3
-----END PGP SIGNATURE-----

--==_Exmh_1175813262_18759P--
