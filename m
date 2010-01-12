Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007Ab0ALOad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0ALOad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 09:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895Ab0ALOac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 09:30:32 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38873 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0ALOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 09:30:30 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: Michael Stone <michael@laptop.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
In-Reply-To: Your message of "Tue, 12 Jan 2010 08:59:27 +0100."
             <20100112075927.GA24256@atrey.karlin.mff.cuni.cz>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org> <20100110215409.GA3705@heat> <20100110215848.GA26609@elf.ucw.cz> <5768.1263264853@localhost>
            <20100112075927.GA24256@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1263306523_4979P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Jan 2010 09:28:43 -0500
Message-ID: <32558.1263306523@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail: UCE(50)
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=50/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=bulk(0),
	refid=str=0001.0A020201.4B4C8720.00CD,ss=3,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1263306523_4979P
Content-Type: text/plain; charset=us-ascii

On Tue, 12 Jan 2010 08:59:27 +0100, Pavel Machek said:

> Well, maybe, but mailer system where first user starts is as a daemon
> makes sense...

Does it?  How do you get port 25 open for listening if the first user isn't
root?  Most *actual* schemes to "launch at first use" that require privs for
something have used inetd or similar - that program exists for a *reason*.

--==_Exmh_1263306523_4979P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLTIcbcC3lWbTT17ARAr8PAJ94bDdQldxM7RZrZfTZGf16tCxRBQCgodDB
rBzAtNDSU79QFaso6ka4onU=
=Sa8Z
-----END PGP SIGNATURE-----

--==_Exmh_1263306523_4979P--

