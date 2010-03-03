Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab0CCT4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:56:51 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:39688 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab0CCT4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:56:46 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-03-02 - kernel BUG at fs/direct-io.c:630
In-Reply-To: Your message of "Wed, 03 Mar 2010 21:55:10 +0300."
             <87pr3lkzg1.fsf@openvz.org>
From: Valdis.Kletnieks@vt.edu
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org> <10679.1267639769@localhost>
            <87pr3lkzg1.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1267646150_4777P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Mar 2010 14:55:50 -0500
Message-ID: <5057.1267646150@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4B8EBEC7.0014,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1267646150_4777P
Content-Type: text/plain; charset=us-ascii

On Wed, 03 Mar 2010 21:55:10 +0300, Dmitry Monakhov said:
> Valdis.Kletnieks@vt.edu writes:
> 
> > On Tue, 02 Mar 2010 18:39:07 PST, akpm@linux-foundation.org said:
> >> The mm-of-the-moment snapshot 2010-03-02-18-38 has been uploaded to
> >> 
> >>    http://userweb.kernel.org/~akpm/mmotm/
> >
> > This goes kersplat at boot for me. x86_64 on a Dell Latitude E6500.
> http://bugzilla.kernel.org/show_bug.cgi?id=15424
> already fixed.

Confirming that fixed it, thanks.  Am now up on 33-mmotm0302.


--==_Exmh_1267646150_4777P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLjr7GcC3lWbTT17ARAi2rAJ4vHRoZgn0IM4RjZ5zSQ9GwGlASWQCfZZKG
W60U40k4jTZqtcGV3JOt07s=
=fPgk
-----END PGP SIGNATURE-----

--==_Exmh_1267646150_4777P--

