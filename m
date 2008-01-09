Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbYAIIVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbYAIIVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYAIIVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:21:12 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58786 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYAIIVM (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:21:12 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: BuraphaLinux Server <buraphalinuxserver@gmail.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: The ext3 way of journalling
In-Reply-To: Your message of "Wed, 09 Jan 2008 15:00:46 +0700."
             <5d75f4610801090000j20eb7c07m78a07abbffe590ba@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <p73odbwqmx2.fsf@bingen.suse.de> <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi> <20080108181525.GL27800@mit.edu> <p734pdoqbva.fsf@bingen.suse.de> <8DEA7347-120C-4A97-A208-2577ED88F799@mac.com>
            <5d75f4610801090000j20eb7c07m78a07abbffe590ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199866868_3703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Jan 2008 03:21:08 -0500
Message-ID: <23767.1199866868@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199866868_3703P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 Jan 2008 15:00:46 +0700, BuraphaLinux Server said:
> The help for CONFIG_DM_SNAPSHOT says it is EXPERIMENTAL (in
> 2.6.23.12).  So this would mean that there is very high risk of
> software failure using snapshots.  Would you want to do that for your
> fsck?

The overall current state of EXPERIMENTAL in the tree is, quite frankly,
somewhere between a complete crock and a wheelbarrow full of bovine fertilizer.
There's a lot of things labeled EXPERIMENTAL that shouldn't be, and a lot of
bleeding edge things that may eat your disks and cause your dog to turn green
that aren't labelled EXPERIMENTAL.

Having said that, I have *no* idea what state the snapshot code is in, but I
have approximately zero confidence that the EXPERIMENTAL tag tells me anything
actually useful about the snapshot code.


--==_Exmh_1199866868_3703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHhIP0cC3lWbTT17ARApC/AKDlP1ovJqASpsFJkbTflFN8eGLrNgCg1Ul6
6qsyttrUFbjoA+cZaZvoMC0=
=tCzs
-----END PGP SIGNATURE-----

--==_Exmh_1199866868_3703P--
