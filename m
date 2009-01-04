Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbZADEv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbZADEv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 23:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZADEvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 23:51:50 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56004 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbZADEvt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 23:51:49 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gabor MICSKO <gmicsko@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Grsecurity is about to be discontinued, unless...
In-Reply-To: Your message of "Sat, 03 Jan 2009 12:16:50 PST."
             <alpine.LFD.2.00.0901031210260.3179@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1231013176.6497.20.camel@localhost.localdomain>
            <alpine.LFD.2.00.0901031210260.3179@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231044704_3941P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 03 Jan 2009 23:51:44 -0500
Message-ID: <24107.1231044704@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231044704_3941P
Content-Type: text/plain; charset=us-ascii

On Sat, 03 Jan 2009 12:16:50 PST, Linus Torvalds said:
> On Sat, 3 Jan 2009, Gabor MICSKO wrote:
> > In short, I would like to know what is your answer to this request. And
> > in the case if you see no chance for the integration, I would like to
> > know what is the reason behind this decision.
> 
> Quite frankly, historically the patches have been a mis-match of
> 
>  - some sane stuff

Probably the best way to proceed would be for the stakeholders to come to some
agreement on which parts are the "sane stuff" (which could be an interesting
food fight), split those parts out, and submit them for inclusion as standalone
separate patches.

It's a shame that the grsecurity developers had issues with the LSM architecture,
as their RBAC would probably be a nice addition to the slowly-growing set of
LSM modules.

--==_Exmh_1231044704_3941P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJYEBgcC3lWbTT17ARAqwuAKCAID6ARFbr4FqYHu338ALTYAiEowCg1YU8
Tqm4z69Ha1ZsmKaT0SxscY8=
=HfcH
-----END PGP SIGNATURE-----

--==_Exmh_1231044704_3941P--
