Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZABQUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZABQUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbZABQU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:20:28 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55477 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZABQU1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:20:27 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Bryan Donlan <bdonlan@gmail.com>,
       Ingo Brueckl <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
In-Reply-To: Your message of "Fri, 02 Jan 2009 21:43:03 +0530."
             <3f9a31f40901020813t136ad2ceif1092f312866a0ce@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <495d2974@wupperonline.de> <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com> <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com> <20090102093801.GD1975@elte.hu> <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com> <11444.1230910752@turing-police.cc.vt.edu>
            <3f9a31f40901020813t136ad2ceif1092f312866a0ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1230913212_3517P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Jan 2009 11:20:12 -0500
Message-ID: <13903.1230913212@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1230913212_3517P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Jan 2009 21:43:03 +0530, Jaswinder Singh Rajput said:

> Let me know why should I choose EMBEDDED option ? I know I am not
> using Embbeded machine and I do not need embbeded features on my
> machine. If I am willing to go North why should I go South first ?

EMBEDDED is a bad name for the option.  It *started* as "only those
maniac who need to trim their kernel WAY down should select this", and
ended up as "stuff that 95% of users shouldn't change, but you can if you
know what you're doing".

--==_Exmh_1230913212_3517P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJXj68cC3lWbTT17ARAid1AKDxbMsreeC3z55e3gAvOum+ibDBPACeLRLG
qHvhlYO2yMotkZxaJhvr2U0=
=JnZs
-----END PGP SIGNATURE-----

--==_Exmh_1230913212_3517P--
