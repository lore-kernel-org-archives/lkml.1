Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbYCGPV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbYCGPV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYCGPVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:21:20 -0500
Received: from hc6521041.dhcp.vt.edu ([198.82.16.65]:43803 "EHLO
	hc6521041.dhcp.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbYCGPVT (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:21:19 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4
In-Reply-To: Your message of "Fri, 07 Mar 2008 09:57:48 +0100."
             <20080307085748.GM17940@kernel.dk>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080306090029.GA6215@elte.hu> <20080306125929.GD17940@kernel.dk> <20080306130643.GB21359@elte.hu> <20080307085341.GA23814@elte.hu>
            <20080307085748.GM17940@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204903213_4420P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Mar 2008 10:20:14 -0500
Message-ID: <26060.1204903214@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204903213_4420P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Mar 2008 09:57:48 +0100, Jens Axboe said:

> To capture vital debugging information for cases like this, I had an
> idea for a sysrq key that would dump queue and io scheduler info for all
> known block devices. That should help pin point where the problem lies.
> If we have any letters left in the sysrq namespace :-)

Time for alt-sysrq-cokebottle? :)

--==_Exmh_1204903213_4420P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH0V0tcC3lWbTT17ARAjT/AKDpUBnpamiUa6wioSS//Is5czdymgCfYlNs
QUONJKWKrwZIFVhIrYnlV0c=
=wuV5
-----END PGP SIGNATURE-----

--==_Exmh_1204903213_4420P--
