Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbZL3Q00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbZL3Q00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZL3Q0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:26:25 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:48497 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbZL3Q0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:26:23 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: daw-news@taverner.cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: disablenetwork facility. (v4)
In-Reply-To: Your message of "Wed, 30 Dec 2009 07:24:11 GMT."
             <hhev6r$n8b$1@taverner.cs.berkeley.edu>
From: Valdis.Kletnieks@vt.edu
References: <20091229050114.GC14362@heat> <m1y6km11lj.fsf@fess.ebiederm.org>
            <hhev6r$n8b$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262190380_4341P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 30 Dec 2009 11:26:20 -0500
Message-ID: <6828.1262190380@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4B3B7F2C.00EB,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262190380_4341P
Content-Type: text/plain; charset=us-ascii

On Wed, 30 Dec 2009 07:24:11 GMT, David Wagner said:
> So while I certainly can't rule out the possibility that disablenetwork
> might introduce minor issues, I think there are fundamental reasons to
> be skeptical that disablenetwork will introduce serious new security
> problems.

I have to agree with David here - although there's many failure modes if
a security-relevant program wants to talk to the network, they're all already
prone to stuffage by an attacker.

Biggest danger is probably programs that rashly assume that 127.0.0.1 is
reachable.  Seen a lot of *that* in my day (no, don't ask how I found out ;)


--==_Exmh_1262190380_4341P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLO38scC3lWbTT17ARAhKTAJ4zVa5ro+yZ35sWwXfxsMgruv8NRACdFCLV
Lxrf4R47wnDXhP6w+UbPGKo=
=PKrW
-----END PGP SIGNATURE-----

--==_Exmh_1262190380_4341P--

