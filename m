Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZKCSpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZKCSpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZKCSpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:45:11 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52726 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZKCSpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:45:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Reg Clemens <reg@dwf.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Can build 2.6.31.5 on one P4 but not another.
In-Reply-To: Your message of "Tue, 03 Nov 2009 11:15:12 MST."
             <200911031815.nA3IFCe6017661@deneb.dwf.com>
From: Valdis.Kletnieks@vt.edu
References: <200911031815.nA3IFCe6017661@deneb.dwf.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257273906_4220P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Nov 2009 13:45:06 -0500
Message-ID: <8575.1257273906@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4AF07A34.012A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257273906_4220P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 Nov 2009 11:15:12 MST, Reg Clemens said:
> Can someone explain this to me.

> I dont understand how this can build on one P4 and not another.

Different .configs?  gcc?  binutils?  Those are the first 3 that come to mind...

--==_Exmh_1257273906_4220P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8HoycC3lWbTT17ARAimrAKDhV7fYoR9ugFL3DjcEODt5uSIPuQCfaPAc
c2HUBAUUs97nmQ4n2Nv8szQ=
=vM81
-----END PGP SIGNATURE-----

--==_Exmh_1257273906_4220P--

