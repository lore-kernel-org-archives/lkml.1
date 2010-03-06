Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0CFRXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 12:23:52 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:53822 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0CFRXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 12:23:50 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Daniel Stone <daniel@fooishbar.org>
Cc: David Miller <davem@davemloft.net>, skeggsb@gmail.com, airlied@linux.ie,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net, mingo@elte.hu, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] drm request 3
In-Reply-To: Your message of "Fri, 05 Mar 2010 18:04:34 +0200."
             <20100305160434.GE2505@tempa>
From: Valdis.Kletnieks@vt.edu
References: <20100305151754.GB2505@tempa> <20100305.072612.186421758.davem@davemloft.net> <20100305154009.GC2505@tempa> <20100305.074835.159078083.davem@davemloft.net>
            <20100305160434.GE2505@tempa>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1267896078_4049P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 06 Mar 2010 12:21:18 -0500
Message-ID: <11879.1267896078@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4B928F10.0107,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1267896078_4049P
Content-Type: text/plain; charset=us-ascii

On Fri, 05 Mar 2010 18:04:34 +0200, Daniel Stone said:

> So you're saying that there's no way to develop any reasonable body of
> code for the Linux kernel without committing to keeping your ABI
> absolutely rock-solid stable for eternity, no exceptions, ever? Cool,
> that worked really well for Xlib.

Amen to that.  I can remember the X10.4->X11 conversion in 1987. And a heck of
a lot of source-level stability since then (even with the libX11 getting redone
with libxcb under it. 23 years and still going strong is one hell of a good run
for an ABI.


--==_Exmh_1267896078_4049P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLko8OcC3lWbTT17ARAp98AKCGEsV0EPYglJJSpdkT5sODNtid6QCffEYK
oH2sKaRr4a/yPoPgmX1rxOg=
=n3f9
-----END PGP SIGNATURE-----

--==_Exmh_1267896078_4049P--

