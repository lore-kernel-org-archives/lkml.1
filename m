Return-Path: <linux-kernel-owner+w=401wt.eu-S1761568AbZD1PSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568AbZD1PSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbZD1PSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:18:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43916 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317AbZD1PSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:18:06 -0400
Date: Wed, 29 Apr 2009 01:17:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 11/14] powerpc: Use macros for .data.page_aligned
 section.
Message-Id: <20090429011756.6cccbc7d.sfr@canb.auug.org.au>
In-Reply-To: <20090429010753.851e0f59.sfr@canb.auug.org.au>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
	<1240864388-26315-2-git-send-email-tabbott@mit.edu>
	<1240864388-26315-3-git-send-email-tabbott@mit.edu>
	<1240864388-26315-4-git-send-email-tabbott@mit.edu>
	<1240864388-26315-5-git-send-email-tabbott@mit.edu>
	<1240864388-26315-6-git-send-email-tabbott@mit.edu>
	<1240864388-26315-7-git-send-email-tabbott@mit.edu>
	<1240864388-26315-8-git-send-email-tabbott@mit.edu>
	<1240864388-26315-9-git-send-email-tabbott@mit.edu>
	<1240864388-26315-10-git-send-email-tabbott@mit.edu>
	<1240864388-26315-11-git-send-email-tabbott@mit.edu>
	<1240864388-26315-12-git-send-email-tabbott@mit.edu>
	<20090429010753.851e0f59.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Apr_2009_01_17_56_+1000_7t_2EKfvSxU9SVmT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Apr_2009_01_17_56_+1000_7t_2EKfvSxU9SVmT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Apr 2009 01:07:53 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> This moves the page_aligned section from a common part of the
> vmlinux.lds to a 32 bit only part.  Was that intentional?

Just saw your later patches, so ignore this.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Apr_2009_01_17_56_+1000_7t_2EKfvSxU9SVmT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn3HiQACgkQjjKRsyhoI8wYnQCgtVLjC0ymSa8ExUYejFYABlnq
xh4AnjxqlGPU3jrnx6yxubkifNykP7IJ
=eakv
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Apr_2009_01_17_56_+1000_7t_2EKfvSxU9SVmT--
