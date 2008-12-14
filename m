Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbYLNVLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbYLNVLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 16:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYLNVLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 16:11:31 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:49887 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbYLNVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 16:11:30 -0500
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.36,220,1228086000";   d="scan'208";a="93731149"
Date: Sun, 14 Dec 2008 22:11:27 +0100
From: markus reichelt <ml@mareichelt.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27.9
Message-id: <20081214211127.GC3928@tatooine.rebelbase.local>
Mail-followup-to: linux-kernel@vger.kernel.org
References: <20081214001029.GA915@kroah.com>
 <pan.2008.12.14.08.06.53.334750@wizards.de> <20081214190829.GA31396@kroah.com>
 <49456C76.20006@wizards.de>
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=V88s5gaDVPzZ0KCq
Content-disposition: inline
In-reply-to: <49456C76.20006@wizards.de>
Organization: still stuck in reorganization mode
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Holger Hoffst=E4tte <holger@wizards.de> wrote:

> That's really all I know.

Apart from all the mainline excuses why patches aren't accepted - I'd
REALLY like to know why each and every 2.6.27 kernel so totally fails
on me when it comes to X ... the vesa driver refuses to come up
with the magic to do its 75 Hz wonders of the pre .27 series.

Really, there's no error that I could track down to solve the
problem. X seems to run in a loop (unkillable), but a reboot works
(if there's not a kernel panic and hard lockup involved first whilst
me trying to get the darn thing working) - my screen even tells me
during these desperate times that there's no signal. Awesome.=20

Seems like other people encountered the same problem but short of
getting rubbed the obvious answers in their faces, namely mentioning
some magic spell to cope with nvidia (well, doh!), nothing of
substance ever really has come up. Bummer.

Framebuffer or not, radeon driver or not, vesa driver or
not, I still get that 60 Hz eye cancer at best. Sucks. MTRR cleanup
enabled, PAT enabled or not, nada.

Strangely, this reminds me of my hatred towards VIA and its Nehemiah
scam. Suitcase nukes, what a wonderful concept :)


I hope the new mainboard (GMA 3100) works out of the box, cos the
current ancient (!) ati card gives me nothing but a headache on .27.

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV250
If [Radeon 9000] (rev 01) (prog-if 00 [VGA controller])
        Subsystem: PC Partner Limited RV250 If [Sapphire Radeon 9000
Pro]
        Flags: bus master, stepping, 66MHz, medium devsel, latency
64, IRQ 19
        Memory at e8000000 (32-bit, prefetchable) [size=3D64M]
        I/O ports at a800 [size=3D256]
        Memory at ff4f0000 (32-bit, non-prefetchable) [size=3D64K]
        Expansion ROM at ff4c0000 [disabled] [size=3D128K]
        Capabilities: [58] AGP version 2.0
        Capabilities: [50] Power Management version 2
        Kernel driver in use: radeonfb

Writing this on 2.6.26.8. .... Just venting, dont mind me.

--=20
left blank, right bald

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklFdn8ACgkQLMyTO8Kj/uSSOACghJ3IHLswsGrFlz5owuQYKnVt
SXkAnA7SfILUlKDZmlaZOJHjHG8BmI93
=yPrI
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
