Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZDPP1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZDPP1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZDPP1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:27:15 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36369 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZDPP1O (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:27:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: Your message of "Thu, 16 Apr 2009 02:50:25 +0200."
             <20090416005025.GA2779@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu> <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain> <20090415224017.GA18764@elte.hu> <alpine.LFD.2.00.0904151607010.4042@localhost.localdomain> <20090416000841.GA18185@elte.hu> <alpine.LFD.2.00.0904151717040.4042@localhost.localdomain> <alpine.LFD.2.00.0904151736140.4042@localhost.localdomain>
            <20090416005025.GA2779@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1239895461_6564P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Apr 2009 11:24:21 -0400
Message-ID: <23823.1239895461@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1239895461_6564P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Apr 2009 02:50:25 +0200, Ingo Molnar said:

> Something like:

Avoid the passive voice when feasible.

>  The impact of this change is that the build is fixed.

Fix the build breakage caused by bad #include screwage.

>  The impact of this change is that the code gets cleaner.

Neaten up the spaghetti code.

>  The impact of this change is that the CPU does not overheat.

Prevent the CPU from overheating.

Good clear concise writing doesn't need an 'Impact:' to draw attention to it.

About the *only* use case that I've seen that actually makes *any* sense is
the *one* case where adding "fix on s390 and x86" to the original Subject:
line caused it to be overlong.

--==_Exmh_1239895461_6564P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ502lcC3lWbTT17ARAtmyAJ4qNM993AGmNqWDpIyArkclpErQ1QCgxGpo
f3Q6BckHuMX91GcJP/HTQDc=
=giwu
-----END PGP SIGNATURE-----

--==_Exmh_1239895461_6564P--
