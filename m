Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbYDKUHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbYDKUHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbYDKUG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:06:58 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45028 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321AbYDKUG5 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:06:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mark Lord <lkml@rtr.ca>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       =?UTF-8?B?SWxwbyBKw6RydmluZW4=?= <ilpo.jarvinen@helsinki.fi>,
       David Miller <davem@davemloft.net>, jesper.juhl@gmail.com,
       tilman@imap.cc, yoshfuji@linux-ipv6.org, Jeff Garzik <jeff@garzik.org>,
       rjw@sisk.pl, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.25-rc8: FTP transfer errors
In-Reply-To: Your message of "Fri, 11 Apr 2008 10:59:57 EDT."
             <47FF7CED.9090601@rtr.ca>
From: Valdis.Kletnieks@vt.edu
References: <47FEADCB.7070104@rtr.ca> <20080410.172453.44434205.davem@davemloft.net> <47FEB062.3020003@rtr.ca> <20080410.173911.179180620.davem@davemloft.net> <47FEBDAA.7010305@rtr.ca> <Pine.LNX.4.64.0804110849520.28360@wrl-59.cs.helsinki.fi> <47FF6555.50004@rtr.ca> <20080411143537.GA27874@2ka.mipt.ru>
            <47FF7CED.9090601@rtr.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1207943927_4539P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Apr 2008 15:58:47 -0400
Message-ID: <22897.1207943927@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1207943927_4539P
Content-Type: text/plain; charset=us-ascii

On Fri, 11 Apr 2008 10:59:57 EDT, Mark Lord said:

> The one thing I did not have time for initially,
> was a painstaking blunt instrument binary search of
> every commit since v2.6.24.

The nice thing about binary search is that it's by definition an
O(log2(N)) operation, which isn't bad at all as far as algorithms go.

The truly blunt instrument here would be a linear search of every commit...



--==_Exmh_1207943927_4539P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH/8L3cC3lWbTT17ARAqJAAKC17YoTbNXtjO74Cjix2TH8lXnMEgCgxEhM
zVFXyJR40oOzhDfY/4004+k=
=DXhx
-----END PGP SIGNATURE-----

--==_Exmh_1207943927_4539P--
