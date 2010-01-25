Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658Ab0AYFex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab0AYFex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 00:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248Ab0AYFew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 00:34:52 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:40932 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0AYFew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 00:34:52 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High pitch noise when ACPI processor module is loaded.
In-Reply-To: Your message of "Sat, 23 Jan 2010 10:48:50 EST."
             <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan>
From: Valdis.Kletnieks@vt.edu
References: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1264397678_4500P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 25 Jan 2010 00:34:38 -0500
Message-ID: <9883.1264397678@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4B5D2D74.0130,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1264397678_4500P
Content-Type: text/plain; charset=us-ascii

On Sat, 23 Jan 2010 10:48:50 EST, Justin Piszcz said:
> Hi,
> 
> Linux:
> When I do not load the ACPI processor module, there is no high pitch 
> noise.  When I load the ACPI processor module (so I can utilize Turbo 
> Boost), Linux makes the system emit a high pitch noise.

Sounds like singing capacitors.

http://lwn.net/Articles/145973/ - and see the last 2 comments.



--==_Exmh_1264397678_4500P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLXS1ucC3lWbTT17ARArawAKD9Myt8RHIA17tdOB0qpWI/eUZy1gCgwrA6
BIJOdwQuQcjAmUtTWlmNnrU=
=sSgS
-----END PGP SIGNATURE-----

--==_Exmh_1264397678_4500P--

