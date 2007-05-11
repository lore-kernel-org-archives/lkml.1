Return-Path: <linux-kernel-owner+w=401wt.eu-S1761836AbXEKPGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761836AbXEKPGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 11:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbXEKPF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 11:05:59 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36283 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968AbXEKPF6 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 11:05:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Christoph Hellwig <hch@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/10] Linux Kernel Markers - Documentation
In-Reply-To: Your message of "Thu, 10 May 2007 07:58:47 BST."
             <20070510065847.GE8019@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <20070510015555.973107048@polymtl.ca> <20070510020917.172554217@polymtl.ca>
            <20070510065847.GE8019@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178895937_3561P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 11 May 2007 11:05:37 -0400
Message-ID: <5936.1178895937@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178895937_3561P
Content-Type: text/plain; charset=us-ascii

On Thu, 10 May 2007 07:58:47 BST, Christoph Hellwig said:
> On Wed, May 09, 2007 at 09:56:02PM -0400, Mathieu Desnoyers wrote:
> > Here is some documentation explaining what is/how to use the Linux
> > Kernel Markers.
> 
> Please remove all references to out of tree code from the kernel documentation.

[/usr/src/linux-2.6.21-mm2/Documentation] find . | xargs grep /sbin | wc -l
202

-ENOPATCH?

(The usefulness of a kernel documentation tree that doesn't mention hotplug,
udev, modprobe, and initrd, all of which are out-of-tree, is more than slightly
questionable...)


--==_Exmh_1178895937_3561P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGRIZBcC3lWbTT17ARAtTsAJ9bJbrytfReP+573nLbOeXqIPSYyACgmeeL
B+HhBqLQDKAhfx8frUfTVLg=
=lDgl
-----END PGP SIGNATURE-----

--==_Exmh_1178895937_3561P--
