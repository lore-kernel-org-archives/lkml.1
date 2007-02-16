Return-Path: <linux-kernel-owner+w=401wt.eu-S1751543AbXBPKah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbXBPKah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXBPKag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:30:36 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47823 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXBPKag (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:30:36 -0500
Message-Id: <200702161030.l1GAUXmI026421@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: v j <vj.linux@gmail.com>
Cc: Trent Waddington <trent.waddington@gmail.com>,
       David Lang <david.lang@digitalinsight.com>,
       Scott Preece <sepreece@gmail.com>, Miguel Ojeda <maxextreme@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: Your message of "Thu, 15 Feb 2007 22:25:12 PST."
             <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com> <20070215165339.GB5285@thunk.org> <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com> <653402b90702151102n3a3e0435r837e2191de79b2b@mail.gmail.com> <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com> <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz> <9b3a62ab0702152148p57db8b1dgd42b1c6fb15dccbb@mail.gmail.com> <3d57814d0702152157n461a9f0cta0a0c20e9a592d83@mail.gmail.com>
            <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1171621833_6166P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Feb 2007 05:30:33 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1171621833_6166P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Feb 2007 22:25:12 PST, v j said:

(Damn, hit send too soon)

> No, just that the trend is disturbing. If enough Kernel Developers
> choose to write their Software in a way that prevents others from
> using it freely, then that is troubling. Especially when these Kernel
> Developers are substituting existing interfaces in the Kernel with
> ones that are NEW and require specific licenses.

Again - there's nothing stopping you from fixing *your* copy to work
any way you want. I freely admit that *my* kernel is quite often running
code that I don't want to release under the GPL (usually because it's too
ghastly for submission in-tree :) - but that's OK, because I don't let that
sort of code escape. :)

There's nothing stopping you from shipping a GPL'ed patch that fixes it the way
you want it to work, to any and all who want to install your patch. I've done
that too - posted "provably incorrect, but works for me" patches for bugs I've
hit. Once in a while, my "provably incorrect" assertion even turns out to be
itself incorrect. ;)

There's nothing stopping you from shipping GPL'ed code that lies about
its MODULE_LICENSE.  But if you're shipping *non*-GPL'ed code that does
that sort of thing, you demonstrate that you *knew* what the author thought
about derivative works.

So you really have 4 options:

0) Don't ship code.  Send a board and a spec sheet to Greg KH. :)
1) Release it properly under the GPL.
2) Consult a lawyer, and decide to risk shipping it non-GPL.
3) Rebase your code so it runs on a *BSD or vxworks or other OS where
your code's licence and the OS license are known to be compatible.

Pick one, and live with it.

--==_Exmh_1171621833_6166P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF1YfJcC3lWbTT17ARAn4IAJwNuINV6uxhFjaXvCql472aM6jFvACeJ+r9
gqNqGABuRcvJ0ZAAmZtC6nw=
=b1+m
-----END PGP SIGNATURE-----

--==_Exmh_1171621833_6166P--
