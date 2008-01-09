Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbYAIUoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbYAIUoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYAIUoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:44:38 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42378 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbYAIUoi (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:44:38 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Roskin <proski@gnu.org>, benh@kernel.crashing.org,
       Dave Airlie <airlied@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com
Subject: Re: Replacement for page fault notifiers?
In-Reply-To: Your message of "Wed, 09 Jan 2008 20:26:44 GMT."
             <20080109202644.GA5514@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi> <20080108203235.GA772@infradead.org> <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com> <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv> <20080109182157.GA32754@infradead.org> <1199908703.6734.133.camel@pasglop> <1199910256.11485.14.camel@dv>
            <20080109202644.GA5514@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199911462_3223P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Jan 2008 15:44:22 -0500
Message-ID: <25871.1199911462@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199911462_3223P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 Jan 2008 20:26:44 GMT, Christoph Hellwig said:

> > Exactly.  In MadWifi, they are inlined on i386 and x86_64, and I cannot
> > ask every user with an unsupported card to get a Mac.
> 
> Maybe it's time to do some simple xoring in the ioremap return value
> to force them not to do such stupid things..

If an open-source driver did exactly the same thing, would it still be
stupid?  If so, what should it be doing instead?

--==_Exmh_1199911462_3223P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHhTImcC3lWbTT17ARAoIBAKDoAzI83/4f6eCA7eZ0ykJXIEhHEwCg6LmA
vHRJspxOTiAzntiW/DHvAew=
=1m8A
-----END PGP SIGNATURE-----

--==_Exmh_1199911462_3223P--
