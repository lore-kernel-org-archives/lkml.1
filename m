Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZG0Spl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZG0Spl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZG0Spk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:45:40 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42219 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZG0Spk (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:45:40 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Anupama Chandwani <anupama.chandwani@gmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Undefined symbol "min_low_pfn"
In-Reply-To: Your message of "Mon, 27 Jul 2009 11:17:20 PDT."
             <689eb3470907271117x4638464p72964819a80637c0@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <689eb3470907271102i904d81em6317302e373e0730@mail.gmail.com>
            <689eb3470907271117x4638464p72964819a80637c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248720339_3074P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 14:45:39 -0400
Message-ID: <52058.1248720339@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248720339_3074P
Content-Type: text/plain; charset=us-ascii

On Mon, 27 Jul 2009 11:17:20 PDT, Anupama Chandwani said:

> I want to know what pages (page frame numbers) are used by kernel
> code/data/bss etc. min_low_pfn would have told me the lowest usable
> pfn.
> Is there another way of getting this information? Or printing the min_low_pfn?

What are you trying to do with that number?  Perhaps if you explain the
problem you're trying to solve by looking at min_low_pfn, somebody will have
a better solution...


--==_Exmh_1248720339_3074P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKbfXTcC3lWbTT17ARAgEQAKCOM+zx42gQzoHxPDuFhQ+gTBEF1wCeIByt
Xb+jUVFQ+2rQl4OSrlRZbOE=
=b2hV
-----END PGP SIGNATURE-----

--==_Exmh_1248720339_3074P--
