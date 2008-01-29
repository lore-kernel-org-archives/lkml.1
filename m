Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbYA2W2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbYA2W2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYA2W2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:28:09 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51303 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYA2W2I (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:28:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
In-Reply-To: Your message of "Tue, 29 Jan 2008 16:22:45 EST."
             <1201641765.18773.35.camel@dv>
From: Valdis.Kletnieks@vt.edu
References: <1201641765.18773.35.camel@dv>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201645637_2881P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 29 Jan 2008 17:27:17 -0500
Message-ID: <24944.1201645637@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201645637_2881P
Content-Type: text/plain; charset=us-ascii

On Tue, 29 Jan 2008 16:22:45 EST, Pavel Roskin said:
> Hello!
> 
> It have come to my attention that a patch has been committed to the
> kernel with the explicit purpose of tainting ndiswrapper - the kernel
> module allowing Windows NDIS drivers for Ethernet and Wireless cards to
> be used by the kernel.

At some point, a compromise position of "Have ndiswrapper do the tainting
if it loads something with contentious licensing" was suggested - whatever
happened to that?

(If for no other reason than if you load ndiswrapper for testing, and then
do *not* actually load something, your kernel should remain untainted...)

--==_Exmh_1201645637_2881P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHn6hFcC3lWbTT17ARAha7AJ47mjnDLNqL6PHRY3UmEcTwkviHTACgkvz0
D/r5FonTj6MQcTS+8nX4Ph0=
=XtP1
-----END PGP SIGNATURE-----

--==_Exmh_1201645637_2881P--
