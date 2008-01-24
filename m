Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYAXF1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYAXF1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 00:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbYAXF1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 00:27:16 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51669 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYAXF1P (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 00:27:15 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Jon Masters <jcm@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CONFIG_MARKERS
In-Reply-To: Your message of "Wed, 23 Jan 2008 09:48:12 EST."
             <20080123144811.GA12296@Krystal>
From: Valdis.Kletnieks@vt.edu
References: <1201029235.18144.62.camel@perihelion> <y0modbdnt4e.fsf@ton.toronto.redhat.com> <20080123031005.GA16766@Krystal> <1201061860.25284.28.camel@perihelion> <20080123131442.GA6562@redhat.com>
            <20080123144811.GA12296@Krystal>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201152358_2830P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Jan 2008 00:25:58 -0500
Message-ID: <27267.1201152358@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201152358_2830P
Content-Type: text/plain; charset=us-ascii

On Wed, 23 Jan 2008 09:48:12 EST, Mathieu Desnoyers said:

> This specific one is a kernel policy matter, and I personally don't
> have a strong opinion about it. I agree that you raise a good counter
> argument : it can be useful to proprietary modules users to be able to
> extract tracing information from those modules to argue with their
> vendors that their driver/hardware is broken (a tracer is _very_ useful
> in that kind of situation).

Amen, brother. Been there, done that, got the tshirt (not on Linux, but
other operating systems).

>                             However, it is also useful to proprieraty
> module writers who can benefit from the merged kernel/modules traces.
> Do we want to give them this ability ? 

The proprietary module writer has the *source* for the kernel and their module.
There's no way you can prevent the proprietary module writers from using this
feature as long as you allow other module writers to use it.

>                                           It would surely help writing
> better proprieraty kernel modules.

The biggest complaint against proprietary modules is that they make it
impossible for *us* to debug.  And you want to argue *against* a feature that
would allow them to develop better code that causes less crashes, and therefor
less people *asking* for us to debug it?

Remember - when a user tries a Linux box with a proprietary module, and the
experience sucks because the module sucks, they will walk away thinking
"Linux sucks", not "That module sucks".


--==_Exmh_1201152358_2830P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmCFmcC3lWbTT17ARAqrqAJ0blfilJZPSXmsU7TSBiA6UUtDaEwCdGlX4
hbNl9YoUg9SMOXjrDjnHCoY=
=oBOx
-----END PGP SIGNATURE-----

--==_Exmh_1201152358_2830P--
