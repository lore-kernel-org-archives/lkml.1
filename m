Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbZFLVk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbZFLVk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZFLVkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:40:20 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33049 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbZFLVkT (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:40:19 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "R.F. Burns" <burnsrf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PC speaker
In-Reply-To: Your message of "Fri, 12 Jun 2009 17:28:40 EDT."
             <a800cda90906121428y4a2994dbm4adba5f60eaeafc6@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <a800cda90906121428y4a2994dbm4adba5f60eaeafc6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1244842821_4013P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Jun 2009 17:40:21 -0400
Message-ID: <84678.1244842821@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1244842821_4013P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Jun 2009 17:28:40 EDT, "R.F. Burns" said:
> Is it possible to write a kernel module which, when loaded, will blow
> the PC speaker?

Highly unlikely, as the circuitry *driving* the speaker is probably hard-wired
to not output more than the speaker coils can handle.

You *might* be able to find a way to generate a nasty square wave that will
over time stress the speaker cone - but a "*pow* it's dead"? Probably not.

If your speaker just fried, it's more likely a short or other hardware or
mechanical defect.



--==_Exmh_1244842821_4013P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKMstFcC3lWbTT17ARAr7/AKDUmzIkGXKporS46eonj27bp3W2tACfdgZA
MlFq7TAbk8HYcPY6xwRZFTY=
=o4Ds
-----END PGP SIGNATURE-----

--==_Exmh_1244842821_4013P--
