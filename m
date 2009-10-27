Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbZJ0Lvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbZJ0Lvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 07:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZJ0Lvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 07:51:42 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35309 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbZJ0Lvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 07:51:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Leonidas ." <leonidas137@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Noah Watkins <noah@noahdesu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Difference between atomic operations and memory barriers
In-Reply-To: Your message of "Tue, 27 Oct 2009 00:30:45 +0530."
             <f22d86810910261200n130fda06r46fdbcc808195002@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com> <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com> <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com> <4AE5F04E.3050908@nortel.com>
            <f22d86810910261200n130fda06r46fdbcc808195002@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1256644303_9496P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Oct 2009 07:51:43 -0400
Message-ID: <45208.1256644303@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.98 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4AE6DED0.0006,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1256644303_9496P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Oct 2009 00:30:45 +0530, =22Leonidas .=22 said:

> So we can safely assume that pointer assignment will be done in an
> atomic manner?

Has anybody ever actually made a *production* CPU that had non-atomic
pointer assignments?  And how long before the crazed programmers lynched
and burned the offending CPU designer at the stake? ;)

Non-atomic pointer assignments are the CPU design equivalent of Vogon poe=
try.
Just Say No. With a shotgun if needed.

--==_Exmh_1256644303_9496P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK5t7PcC3lWbTT17ARAkz6AKDk19ZTnmCXmhHWdLtltquvE7xVCQCgwKDP
gKQsp2yg4DgldmdfL0vZipM=
=TxCn
-----END PGP SIGNATURE-----

--==_Exmh_1256644303_9496P--

