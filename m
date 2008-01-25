Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbYAYFNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbYAYFNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYAYFMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:12:55 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56761 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYAYFMy (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:12:54 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Newall <davidn@davidnewall.com>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
In-Reply-To: Your message of "Fri, 25 Jan 2008 12:44:05 +1030."
             <479945ED.7040007@davidnewall.com>
From: Valdis.Kletnieks@vt.edu
References: <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu> <4796081A.7060505@davidnewall.com> <20080122160114.GB23277@does.not.exist> <4798C511.8070305@davidnewall.com> <20080124172414.GD4476@does.not.exist> <4798D10C.6090109@davidnewall.com> <20080124181442.GE4476@does.not.exist>
            <479945ED.7040007@davidnewall.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201237935_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 00:12:16 -0500
Message-ID: <2927.1201237936@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201237935_2846P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Jan 2008 12:44:05 +1030, David Newall said:

> The benefit is not zero.  Repeating myself: While the code is there, it
> encourages either removal or repair.  If the option to remove is taken
> off the table then it will eventually be repaired.

Well, if the 2.4 version hasn't been ported by 2.6.24, maybe we'll check
back in *another* 4 years when we're up to 2.6.48.  There's a limit to
how much "eventually" we should drag along.

We (especially Adrian) remove stuff from the kernel *all the time* with the
notation "If anybody wants to get this hook back, it's easy enough to re-add it
when an actual user shows up".  I don't see why iBCS should be treated any
differently.


--==_Exmh_1201237935_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmW+vcC3lWbTT17ARAt7SAJ4s49QOaywig9F8Y/Du1nR3nKZGUgCdFwpt
GCl+AUFcvCQ5poimM8PJvWg=
=2C/z
-----END PGP SIGNATURE-----

--==_Exmh_1201237935_2846P--
