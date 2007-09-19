Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbXISQk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbXISQk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbXISQkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:40:22 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48771 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbXISQkV (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:40:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Satyam Sharma <satyam@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
In-Reply-To: Your message of "Wed, 19 Sep 2007 01:16:28 EDT."
             <A5318C25-7864-453A-B09A-00232D9EAF2A@mac.com>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr> <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr> <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org> <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in> <20070906150616.GA28565@fieldses.org> <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com> <1189121714.6672.38.camel@heimdal.trondhjem.org> <5B1FC03A-6819-4C6C-91D3-F3022B798EF4@mac.com> <alpine.LFD.0.999.0709190503250.26241@enigma.security.iitk.ac.in>
            <A5318C25-7864-453A-B09A-00232D9EAF2A@mac.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190219938_23458P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Sep 2007 12:38:58 -0400
Message-ID: <31390.1190219938@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190219938_23458P
Content-Type: text/plain; charset=us-ascii

On Wed, 19 Sep 2007 01:16:28 EDT, Kyle Moffett said:

> I am assuming that if the laptop has sufficiently important data on  
> it to warrant the above steps then I am also clueful enough to:
>    (A)  Not carry the laptop around unsecured areas,
>    (B)  Keep a close enough eye on it and be aware that it's gone by  
> the time they get to step 2, OR
>    (C)  Pay somebody to build me a better physical chassis for my laptop

Building a better chassis can be a challenge when the threat model really
*does* include attacks by a well-funded TLA.

http://www.epic.org/crypto/scarfo/murch_aff.pdf

The FBI did an *initial* entry to survey the hardware, and then a total of
*five* other entries before they actually installed it.  Note the technical
and legal requirements required on the KLS (it had to, among other things,
capture PGP passphrases but *not* anything that was typed online).

>                                       Besides, if some government  
> wanted the data on your laptop that bad they'd just pick you up in  
> the middle of the night and torture your password out of you.

See above.  Though I *will* note that several years ago, a Department
of Justice filing regarding the use of wiretaps and similar tools reported
that in every single case that the FBI encountered encryption, it in fact
didn't stop the FBI from getting the info it was looking for.  Presumably,
they either used Scarfo-type devices, or they rolled somebody for the key.

They never *did* break Anthony Pellicano's PGP key, as far as I know....

--==_Exmh_1190219938_23458P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8VCicC3lWbTT17ARAmtDAKD+dGh2W5SLICrDqi6zh8EbEGl3qwCgh0un
TRCLhBXYRRSkMfSP+L9S5Ic=
=F3OO
-----END PGP SIGNATURE-----

--==_Exmh_1190219938_23458P--
