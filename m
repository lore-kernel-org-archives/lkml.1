Return-Path: <linux-kernel-owner+w=401wt.eu-S933829AbXK3LLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829AbXK3LLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbXK3LLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:11:23 -0500
Received: from natgw.netstream.ch ([62.65.128.28]:54367 "EHLO
	denkbrett.schottelius.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752660AbXK3LLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:11:22 -0500
X-Greylist: delayed 5399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 06:11:21 EST
Date: Thu, 29 Nov 2007 23:13:00 +0100
From: Nico Schottelius <nico-linux-20071129@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Thanks for /dev/input/* and acpi!
Message-ID: <20071129221300.GC27659@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20071129@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q0rSlbzrZN6k9QnT"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: denkbrett running Linux 2.6.23.9 on i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello everybody!

I'm just playing around with netlink and all the interesting event
devices in 2.6.23.9, because I see that acpid still uses
/proc/acpi/event.

And I must say that the whole event system is pretty fun:
Easy to use, mostly documentated in linux/input.h and
helpful ioctl()s.

I did some hacking on it and if somebody wants to see his / her
acpi events without /proc/acpi/event, she / he can try some of the hacks
under

http://unix.schottelius.org/cgi-bin/gitweb.cgi?p=3Dlinux-event-netlink.git;=
a=3Dsummary

Many greetings,

Nico

P.S.: If you reply, CC me, not subscribed.
P.P.S.: If I see how easy it is, I really think of spending some time on
        gpm again, to resurrect it and the work on gpm2...

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--Q0rSlbzrZN6k9QnT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHTzlsuL75KpiFGIwRAleQAJ4gDZXsc1ttHmbAJ5LtRONOBQOUOQCgxvm3
tKwP2+ft9qygG4RtiLTS2X4=
=2SMP
-----END PGP SIGNATURE-----

--Q0rSlbzrZN6k9QnT--
