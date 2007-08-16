Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbXHPOEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbXHPOEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 10:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758697AbXHPOE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 10:04:26 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37801 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbXHPOEZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 10:04:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Susanne Oberhauser <froh@novell.com>
Cc: Jan Blunck <jblunck@suse.de>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       opensuse-kernel@opensuse.org, opensuse@opensuse.org
Subject: Re: Testing the Current Upstream Kernel
In-Reply-To: Your message of "Thu, 16 Aug 2007 12:28:34 +0200."
             <s2iwsvvlqnh.fsf@byron.suse.de>
From: Valdis.Kletnieks@vt.edu
References: <s2ihcn1vwob.fsf@totally-fudged-out-message-id>
            <s2iwsvvlqnh.fsf@byron.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187273061_618P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Aug 2007 10:04:21 -0400
Message-ID: <6891.1187273061@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187273061_618P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Aug 2007 12:28:34 +0200, Susanne Oberhauser said:
> Jan Blunck <jblunck=40suse.de> writes:
>=20
> > With our openSUSE Build Service we build a daily kernel, where we tak=
e
> > nightly snapshots of the current upstream development kernel (Linus' =
kernel
> > tree linux-2.6.git) without any patches (besides those we need for bu=
ilding a
> > RPM).  We do call this the vanilla kernel. It can be downloaded from:=

> >=20
> >  http://download.opensuse.org/repositories/Kernel:/Vanilla/SUSE_Facto=
ry/
>=20
> Would it make sense to build it for the other distros as well?  like
> debian, fedora and mandrake?  I mena in _theory_ we could build it for
> those distros in the build server, couldn't we?

Most of the distros prefer a chance to add their own =22Special Sauce=22 =
to it
before building, and building inside their build environment (for instanc=
e,
Fedora RPM's get PGP-signed - *that* would be a trust issue right there).=


The current Fedora Rawhide kernel is 'kernel-2.6.23-0.105.rc3.fc8', and a=
 few
RPMs ago it was based against -rc2-git5, so they track *very* close.  I t=
hink
that crew is managing well enough without help from the kernel.org build
server.


--==_Exmh_1187273061_618P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGxFllcC3lWbTT17ARAtTDAKDDn8ATA6WPugpHLVL18VBUVuJZtQCdFUdX
ukqZTKh7IJX4KVrUs0jllXo=
=RW53
-----END PGP SIGNATURE-----

--==_Exmh_1187273061_618P--
