Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbZANEYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbZANEYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 23:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZANEYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 23:24:22 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56182 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZANEYV (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 23:24:21 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Rientjes <rientjes@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
In-Reply-To: Your message of "Wed, 14 Jan 2009 02:35:02 +0300."
             <20090113233502.GA31490@ioremap.net>
From: Valdis.Kletnieks@vt.edu
References: <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net> <alpine.DEB.2.00.0901131459001.22290@chino.kir.corp.google.com>
            <20090113233502.GA31490@ioremap.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231907037_3915P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Jan 2009 23:23:57 -0500
Message-ID: <6507.1231907037@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231907037_3915P
Content-Type: text/plain; charset=us-ascii

On Wed, 14 Jan 2009 02:35:02 +0300, Evgeniy Polyakov said:

> It is exactly the purpose of the patch: to kill what is requested to be
> killed.
> 
> I wonder how do you expect users to guess via libastral that even
> adjusted score does not work, since it happens that task is so special,
> that it can not be killed :)

What does your patch do if one user has a process 'foo' that they're willing
to have die first, and a process 'bar' that absolutely can't be killed..

Meanwhile, another user has a 'must die first' process 'bar', and a 'must not
die' process 'foo'.

Methinks your patch needs libastral as well?

--==_Exmh_1231907037_3915P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJbWjdcC3lWbTT17ARAlmhAJ9iEwYzN114fXPd7ZbSmWXvjt+WgACfQQqu
gZchyflXHKOQADhtCRf3UnY=
=Iyr9
-----END PGP SIGNATURE-----

--==_Exmh_1231907037_3915P--
