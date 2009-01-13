Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbZAMX1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbZAMX1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931AbZAMX0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:26:53 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50295 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759530AbZAMX0w (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:26:52 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Rientjes <rientjes@google.com>, Bill Davidsen <davidsen@tmr.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
In-Reply-To: Your message of "Tue, 13 Jan 2009 14:54:08 +0300."
             <20090113115408.GA22289@ioremap.net>
From: Valdis.Kletnieks@vt.edu
References: <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com>
            <20090113115408.GA22289@ioremap.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231889165_3146P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Jan 2009 18:26:05 -0500
Message-ID: <30255.1231889165@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231889165_3146P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 Jan 2009 14:54:08 +0300, Evgeniy Polyakov said:

> Who should adjust the scores for newly created processes? Who should
> check that processes in the first group have negative oom ajustment and
> in the second group a positive value? Who determines when its time to
> ajust the scores?

Are you saying that you, as the box's administrator, don't know the answers
to those questions?

Or are you asking what the actual method of implementation is - which process
is supposed to write to (possibly some other process) oom_adjust, and when?

--==_Exmh_1231889165_3146P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJbSMNcC3lWbTT17ARAj6DAJ9M/uF2RsFmrJw21Cz7272i5FA9QQCgxMAt
icU1RDslBGRvR560V5JNTV4=
=RZgH
-----END PGP SIGNATURE-----

--==_Exmh_1231889165_3146P--
