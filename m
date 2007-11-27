Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbXK0XBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbXK0XBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbXK0XBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:01:12 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50511 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbXK0XBK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:01:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Adrian Bunk <bunk@kernel.org>
Cc: Dave Jones <davej@redhat.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
In-Reply-To: Your message of "Tue, 27 Nov 2007 22:09:42 +0100."
             <20071127210942.GF3406@stusta.de>
From: Valdis.Kletnieks@vt.edu
References: <20071122343.446909000@suse.de> <adatznarrzc.fsf@cisco.com> <200711261228.15155.rusty@rustcorp.com.au> <20071126102533.1c774870@freepuppy.rosehill.pdx.hemminger.net> <20071127190037.GB30057@redhat.com>
            <20071127210942.GF3406@stusta.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196204425_2895P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Nov 2007 18:00:25 -0500
Message-ID: <4027.1196204425@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196204425_2895P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Nov 2007 22:09:42 +0100, Adrian Bunk said:

> Are there common reasons why these drivers are not upstream?

Well, on my laptop, I'm currently dragging along 3 out-of-tree kernel modules.
2 are well-known binary blobs so it's between me and the vendor, as usual.

The third is a USB webcam driver that happened to get caught at the wrong
end of the colorspace-conversion-in-kernel bunfight in the V4L playpen.
Somebody wants to figure out how to get the gspca drivers into the kernel,
they're at http://mxhaard.free.fr/download.html waiting for attention. ;)

(Don't look at *me*, I don't understand the code, or the bunfight - I just
happen to have one of the 244 supported webcams, and it works with that driver)

--==_Exmh_1196204425_2895P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHTKGJcC3lWbTT17ARAjgQAKCluFWSSLmEm7HErQspBjK/H//HIACghONZ
fp5ZIi9y3DAH5dIj5ACLViI=
=kEKB
-----END PGP SIGNATURE-----

--==_Exmh_1196204425_2895P--
