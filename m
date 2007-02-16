Return-Path: <linux-kernel-owner+w=401wt.eu-S966264AbXBPJw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966264AbXBPJw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966277AbXBPJw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:52:26 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51810 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966264AbXBPJwZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:52:25 -0500
Message-Id: <200702160952.l1G9qMsY025262@turing-police.cc.vt.edu>
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
Content-Type: multipart/signed; boundary="==_Exmh_1171619542_6166P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Feb 2007 04:52:22 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1171619542_6166P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Feb 2007 22:25:12 PST, v j said:
> > It's written in black and white, in the license.
> 
> Please point me to where it says I cannot load proprietary modules in
> the Kernel.

Nobody can point you there, because it doesn't say that anywhere.

What you do to *your* kernel is *your* business.

The question is what the code you *distribute* to *other* people does. It's
perfectly legal to load proprietary modules into the kernel.  The open question
is whether you're allowed to ship a proprietary module to somebody else.

And that will depend in *great* detail on *exactly* what your module does,
what code it uses, and how it does it.  As others have pointed out, NVidia
and ATI think they're in an OK spot with the way *they* do *their* module,
while many embedded companies, shipping a much different product, have almost
unanimously given in rather than risk a court fight about the GPL.

Of course, most companies will cave in and license rather than fight a
patent troll as well - so you *really* need to discuss *your* case with
a clueful lawyer.

--==_Exmh_1171619542_6166P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF1X7WcC3lWbTT17ARAntSAKCTJ9QuTM/kaV0EYjXi1LrE7keQ2wCfdfvr
jOGHQsaXk9VMiCvQ26TzOls=
=BtHW
-----END PGP SIGNATURE-----

--==_Exmh_1171619542_6166P--
