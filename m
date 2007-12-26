Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbXLZQpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbXLZQpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 11:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXLZQpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 11:45:07 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33963 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbXLZQpG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 11:45:06 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: James Morris <jmorris@namei.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul.moore@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
In-Reply-To: Your message of "Wed, 26 Dec 2007 19:52:56 +1100."
             <Xine.LNX.4.64.0712261949060.10612@us.intercode.com.au>
From: Valdis.Kletnieks@vt.edu
References: <20071222233056.d652743e.akpm@linux-foundation.org> <30638.1198647786@turing-police.cc.vt.edu> <Xine.LNX.4.64.0712261833110.7815@us.intercode.com.au> <10809.1198657525@turing-police.cc.vt.edu>
            <Xine.LNX.4.64.0712261949060.10612@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198687481_2946P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Dec 2007 11:44:42 -0500
Message-ID: <7712.1198687482@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198687481_2946P
Content-Type: text/plain; charset=us-ascii

On Wed, 26 Dec 2007 19:52:56 +1100, James Morris said:
> On Wed, 26 Dec 2007, Valdis.Kletnieks@vt.edu wrote:
> 
> > On Wed, 26 Dec 2007 18:34:26 +1100, James Morris said:
> > 
> > > Can you post your .config ?
> > 
> > The gzip'ed config as of when I quit bisecting is attached.  It's probably
> > not directly usable unless you have a quilt tree that's positioned fairly
> > close to git-lblnet.patch.
> 
> What does the following say ?
> 
> # sestatus  && rpm -q selinux-policy

I'm running MLS in permissive mode, so there shouldn't be any SElinux
denials happening.

--==_Exmh_1198687481_2946P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHcoT5cC3lWbTT17ARAo6VAKCKVtjiVpP4WRZl1xvCd099vY/DRACeJ/Q8
YV3/M2qfce4vs1IplW30u9Y=
=5V0N
-----END PGP SIGNATURE-----

--==_Exmh_1198687481_2946P--
