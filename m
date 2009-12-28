Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbZL1VaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbZL1VaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 16:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZL1VaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 16:30:04 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38879 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZL1VaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 16:30:02 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: RFC: disablenetwork facility. (v4)
In-Reply-To: Your message of "Mon, 28 Dec 2009 21:55:11 +0100."
             <20091228205511.GD1637@ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <20091227190802.GH11737@elf.ucw.cz> <20091228060759.GB13266@heat> <20091228101006.GA19984@elf.ucw.cz> <8817.1262011044@localhost>
            <20091228205511.GD1637@ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262035681_4431P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 28 Dec 2009 16:28:01 -0500
Message-ID: <14362.1262035681@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4B3922E3.0041,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262035681_4431P
Content-Type: text/plain; charset=us-ascii

On Mon, 28 Dec 2009 21:55:11 +0100, Pavel Machek said:

> it is really only required for binaries setuid to someone else, but
> that would be too ugly. (Plus, as someone said, ping is great for
> leaking data out.)

Hmm... How is it "too ugly"?  It's just a 'euid != uid' comparison? Or
am I missing some contortion required?

--==_Exmh_1262035681_4431P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLOSLhcC3lWbTT17ARAg/ZAJ9NYXYgMgDeFldLbAEUOl3ERXBbFgCgphiL
RBooQz2/zh8w6oXPl9jHmII=
=4Hwy
-----END PGP SIGNATURE-----

--==_Exmh_1262035681_4431P--

