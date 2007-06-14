Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbXFNCz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbXFNCz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXFNCzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:55:19 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50270 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbXFNCzS (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:55:18 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Joe Perches <joe@perches.com>
Cc: holzheu@linux.vnet.ibm.com, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
In-Reply-To: Your message of "Wed, 13 Jun 2007 12:04:56 PDT."
             <1181761496.6020.158.camel@localhost>
From: Valdis.Kletnieks@vt.edu
References: <1181747217.29512.9.camel@localhost.localdomain> <20070613175147.GB14355@suse.de> <1181758680.26375.25.camel@localhost.localdomain>
            <1181761496.6020.158.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1181789698_3457P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 13 Jun 2007 22:54:58 -0400
Message-ID: <7344.1181789698@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1181789698_3457P
Content-Type: text/plain; charset=us-ascii

On Wed, 13 Jun 2007 12:04:56 PDT, Joe Perches said:

> I believe it better to simply add __FILE__ & __LINE__ to the
> macro rather than some other externally specified unique
> identifier that adds developer overhead and easily gets stale.

There's been plenty of times I've wished for that.  Now if we just found a way
to do something sane for drivers/net/wireless/mac80211/iwlwifi/base.c ;)

Of course, I'm probably atypical - for me, kernel messages come in two forms,
the kind that are immediately obvious at first reading, and the kind that
you end up having to look at the code and wonder WTF? it was doing inside
that never-should-happen-on-this-hardware while loop in the first place... :)


--==_Exmh_1181789698_3457P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGcK4CcC3lWbTT17ARAp5WAJsGkQ8a2KefOX6HlX7fsjJXOJhTqACffsZ0
I/ZIGs3gPuNy7frhNxuBPGQ=
=UpPb
-----END PGP SIGNATURE-----

--==_Exmh_1181789698_3457P--
