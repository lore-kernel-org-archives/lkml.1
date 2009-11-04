Return-Path: <linux-kernel-owner+w=401wt.eu-S932571AbZKDUmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbZKDUmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932366AbZKDUmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:42:09 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:54495 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbZKDUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:42:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Martin Nybo Andersen <tweek@tweek.dk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: Your message of "Wed, 04 Nov 2009 21:08:01 +0100."
             <Pine.LNX.4.64.0911042104260.8785@artax.karlin.mff.cuni.cz>
From: Valdis.Kletnieks@vt.edu
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <20091104165407.1481bc29@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz> <200911041848.48721.tweek@tweek.dk> <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz> <22108.1257364949@turing-police.cc.vt.edu>
            <Pine.LNX.4.64.0911042104260.8785@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257367314_3622P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Nov 2009 15:41:55 -0500
Message-ID: <23950.1257367315@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4AF1E713.01A8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257367314_3622P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 Nov 2009 21:08:01 +0100, Mikulas Patocka said:
> On Wed, 4 Nov 2009, Valdis.Kletnieks@vt.edu wrote:
> 
> > On Wed, 04 Nov 2009 19:46:44 +0100, Mikulas Patocka said:
> > 
> > > When I did it (from Etch to Lenny), two programs that I have compiled 
> > > manually ("vim" and "links") stopped working because Etch and Lenny have 
> > > binary-incompatible libgpm.
> > > 
> > > If some library cannot keep binary compatibility, it should be linked 
> > > staticaly, dynamic version shouldn't even exists on the system --- so tha
t 
> > > no one can create incompatible binaries.
> > 
> > No, all they need to do is bump the .so version number.
> 
> That's what Debian did. Obviously, I can extract the old library from the 
> old package. But non-technical desktop user can't.

But the non-technical user probably wouldn't have hand-compiled vim and links
either, so how would they get into that situation?

--==_Exmh_1257367314_3622P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8ecScC3lWbTT17ARAufiAJ4t16XWtwYJtGKy5M8FnuCdYdLiZQCfQZXJ
EJEX0dQiGmxsHRLtD44QaZY=
=g/a3
-----END PGP SIGNATURE-----

--==_Exmh_1257367314_3622P--

