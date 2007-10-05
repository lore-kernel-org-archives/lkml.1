Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbXJERbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbXJERbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 13:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbXJERbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 13:31:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57518 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbXJERbf (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 13:31:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>,
       Peter Staubach <staubach@redhat.com>, nfsv4@linux-nfs.org,
       Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS client git tree...
In-Reply-To: Your message of "Thu, 04 Oct 2007 10:00:50 EDT."
             <1191506450.6685.17.camel@heimdal.trondhjem.org>
From: Valdis.Kletnieks@vt.edu
References: <1191454876.6726.32.camel@heimdal.trondhjem.org> <20071004085206.0a8e37b5@poseidon.drzeus.cx>
            <1191506450.6685.17.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191605410_2884P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Oct 2007 13:30:10 -0400
Message-ID: <30494.1191605410@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191605410_2884P
Content-Type: text/plain; charset=us-ascii

On Thu, 04 Oct 2007 10:00:50 EDT, Trond Myklebust said:

> How about a boot/module parameter to turn it on or off?
> 
> I don't see any point in having a sysctl for something like this: either
> you have legacy applications or you don't. It is not something that you
> switch off as you go off to lunch.

How does Joe Sysadmin tell if he has an affected legacy app or not?

(The obvious "try it and see what breaks" is a non-starter for many places,
because you too easily end up in a loop of "enable it, find 4-5 show stoppers,
turn it off, fix them, lather rinse repease".  Been there, done that, got
the tshirt - a project I got dragged into involves a large storage array that
appears to insist on exporting 64-bit stuff, and a large farm of clients that
are very 64-bit unclean....)

--==_Exmh_1191605410_2884P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHBnSicC3lWbTT17ARAguhAJ4yFFwmHh6NzutHLK6SsMd4NATjhACeJysn
kycLaBtXZeeZfLAErtMYu1E=
=VK65
-----END PGP SIGNATURE-----

--==_Exmh_1191605410_2884P--
