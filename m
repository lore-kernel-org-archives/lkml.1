Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbZA2WTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbZA2WTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZA2WT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:19:29 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35100 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZA2WT3 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:19:29 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old subarchitecture code
In-Reply-To: Your message of "Thu, 29 Jan 2009 23:14:02 +0100."
             <20090129221402.GA1984@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <1233186180-29883-1-git-send-email-mingo@elte.hu> <87vdryw6ql.fsf@basil.nowhere.org> <eada2a070901291324t1a2dbb08hbff7b026c77d69cd@mail.gmail.com>
            <20090129221402.GA1984@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1233267557_3419P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Jan 2009 17:19:17 -0500
Message-ID: <7477.1233267557@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1233267557_3419P
Content-Type: text/plain; charset=us-ascii

On Thu, 29 Jan 2009 23:14:02 +0100, Ingo Molnar said:

> So two days ago it might have made some sense to rip out this code - now 
> there's no pressing need really. We can remove it in a few years once the 
> last beep has been received from those platforms. The numaq code is now 
> quite similar to an old driver in drivers/* - there's no real downside 
> from having it around.

Eventually, somebody will end up submitting a patch that adds the almost
inevitable 'depends on BROKEN' to the appropriate Kconfig...

--==_Exmh_1233267557_3419P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJgitlcC3lWbTT17ARAhrEAJ9yWyUNZEZOpuatw/x6AhJcrKaqogCg301Y
dAugc1+pXdkTYnmS9hDyKBI=
=gqwx
-----END PGP SIGNATURE-----

--==_Exmh_1233267557_3419P--
