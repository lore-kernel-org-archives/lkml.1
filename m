Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbYAYRCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbYAYRCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757134AbYAYRCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:02:33 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43765 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112AbYAYRCc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:02:32 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Frank Seidel <fseidel@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 012/196] nozomi driver
In-Reply-To: Your message of "Fri, 25 Jan 2008 14:21:33 +0100."
             <Pine.LNX.4.64.0801251420320.15243@fbirervta.pbzchgretzou.qr>
From: Valdis.Kletnieks@vt.edu
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-12-git-send-email-gregkh@suse.de> <Pine.LNX.4.64.0801250910230.12676@fbirervta.pbzchgretzou.qr> <200801251344.30427.fseidel@suse.de>
            <Pine.LNX.4.64.0801251420320.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201280542_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 12:02:22 -0500
Message-ID: <9817.1201280542@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201280542_2846P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Jan 2008 14:21:33 +0100, Jan Engelhardt said:
> 
> On Jan 25 2008 13:44, Frank Seidel wrote:
> >> >+/*
> >> >+ * CHANGELOG
> >> 
> >> Changelogs go into git, not files, at least that is what was mentioned
> >> time and again.
> >
> >i removed them
> >
> If you want to keep them, add it to the patch description; that way they will
> be retained in "git log" without expanding the size of the .c file. :)

By all means - if you have text that explains the who/what/why of the patch,
put it in the patch description, so that 6 months later idiots like me have
a fighting chance of figuring out whether the patch incorrectly implements
the right idea, or if it correctly implements the wrong idea. ;)

--==_Exmh_1201280542_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmhYecC3lWbTT17ARAuZ1AJ4/mHCO3nsRBdaWbkg4m0a7xjOxEgCgklqB
fKnps3F4Gb17Y+LQYx0rOOQ=
=2xqA
-----END PGP SIGNATURE-----

--==_Exmh_1201280542_2846P--
