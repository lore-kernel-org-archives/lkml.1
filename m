Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZJEUVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZJEUVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZJEUVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:21:20 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52286 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbZJEUVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:21:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Newall <davidn@davidnewall.com>
Cc: "Jayson R. King" <dev@jaysonking.com>, LKML <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>
Subject: Re: [PATCH 0/4] BFS backport to 2.6.27
In-Reply-To: Your message of "Tue, 06 Oct 2009 03:34:48 +1030."
             <4ACA2730.7000006@davidnewall.com>
From: Valdis.Kletnieks@vt.edu
References: <4AC9B97B.6070900@jaysonking.com> <4AC9C9EC.7070003@jaysonking.com> <4AC9FEBB.8080009@davidnewall.com> <4ACA188B.1020108@jaysonking.com>
            <4ACA2730.7000006@davidnewall.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1254774029_3393P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Oct 2009 16:20:29 -0400
Message-ID: <168327.1254774029@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.35.168 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4ACA550F.0155,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1254774029_3393P
Content-Type: text/plain; charset=us-ascii

On Tue, 06 Oct 2009 03:34:48 +1030, David Newall said:

> Yes, I was trying for irony.  Mime has been around for many decades and
> anybody claiming that they can't cope with them is probably very stupid
> or lying to make some strange point.  Anyway, I'm not trying to change
> the policy, but was only have a snide dig, en passant, at the crufty,
> old, has-been attitude that it represents.

The problem is that with most MUAs, if you do a 'reply and quote text',
it only operates correctly on the first/main body part - doing a 'reply and
quote' to an *attachment* is usually a lot harder, and doing a 'reply and
quote text from both main body and attachment' is usually convoluted enough
that 'Just Hit Delete' becomes tempting...

I've submitted my share of one-liner patches, and they've all been
PGP-signed, so they show up as MIME multiparts - and yet I've never ONCE
been asked to change it.  I have to conclude that it's because although it's
a multipart, it's a multipart that DTRT when a maintainer hits 'reply' -
and that production MUAs still DTWT when dealing with replying to the
attachments rather than the main body....

--==_Exmh_1254774029_3393P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKylUNcC3lWbTT17ARAnN2AJ4mjya76ctj3Sqm617WA/8LsNkc7wCcDvR0
x44TAGy/8iyVdb4IInBQbOI=
=l+ja
-----END PGP SIGNATURE-----

--==_Exmh_1254774029_3393P--

