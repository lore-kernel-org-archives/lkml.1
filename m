Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbXKIUZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbXKIUZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 15:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXKIUYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 15:24:55 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60350 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbXKIUYy (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 15:24:54 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: mgross@linux.intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1 breaks C-state support on Intel T7200 x86_64
In-Reply-To: Your message of "Thu, 08 Nov 2007 14:30:07 PST."
             <20071108223007.GB5775@linux.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <3624.1194542384@turing-police.cc.vt.edu>
            <20071108223007.GB5775@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1194639884_4484P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Nov 2007 15:24:44 -0500
Message-ID: <6010.1194639884@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1194639884_4484P
Content-Type: text/plain; charset=us-ascii

On Thu, 08 Nov 2007 14:30:07 PST, Mark Gross said:

> wing patch fixes up the cpuidle / pm-qos integration.
> 
> I suspect that this is folded into another mm patch but it should fix
> C-state issue identified.

Confirming that patch left my CPUs mostly in C3 again. Thanks.

I'll have to let Mark and Andrew figure out this code's status in the -mm queue.

--==_Exmh_1194639884_4484P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHNMIMcC3lWbTT17ARAul3AKCdgc9INn6KdQvnlkuNNixOJauSWgCgmCgm
SfuMkYaMXG6/9dhntHrDGVo=
=EJ9/
-----END PGP SIGNATURE-----

--==_Exmh_1194639884_4484P--
