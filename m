Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0BSSsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 13:48:10 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:60993 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab0BSSsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 13:48:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Peter Paul <abnominales@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: One Video Decoding API to rule them all
In-Reply-To: Your message of "Fri, 19 Feb 2010 17:39:00 +0100."
             <1266597540.2383.20.camel@virtubuntu-alpha>
From: Valdis.Kletnieks@vt.edu
References: <1266597540.2383.20.camel@virtubuntu-alpha>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1266605284_16275P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 19 Feb 2010 13:48:04 -0500
Message-ID: <22466.1266605284@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4B7EDCE4.0281,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1266605284_16275P
Content-Type: text/plain; charset=us-ascii

On Fri, 19 Feb 2010 17:39:00 +0100, Peter Paul said:

> I think it would therefore be helpful to have an official statement
> which API is the preferable one so, that the open source drivers and
> applications could migrate to that one.

What you need is a statement that API XYZ is the One True API, *and* statements
from the non-XYZ vendors that they intend to move in that direction.  Let's
face it - if you don't get NVidia and AMD saying they're both going in the
same direction, you end up having to support both directions no matter what
we say regarding the desired direction.

Anybody who doesn't believe that is invited to look at some of the APIs that
distros are carrying as patches for 18 months and more, even though Linus
has publicly called the API a piece of crap.

--==_Exmh_1266605284_16275P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLftzkcC3lWbTT17ARApTEAKD2OErIr21JcawNXsfwQIgVGm/pTwCgvP0U
4vibAWxWiIn5t8LtZBSne38=
=ZGQz
-----END PGP SIGNATURE-----

--==_Exmh_1266605284_16275P--

