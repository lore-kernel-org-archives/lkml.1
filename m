Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXE3NmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXE3NmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbXE3NmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:42:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40249 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbXE3NmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:42:13 -0400
Date: Wed, 30 May 2007 23:42:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Robin Holt <holt@sgi.com>
Cc: Stephane Eranian <eranian@frankl.hpl.hp.com>, linux-kernel@vger.kernel.org,
       eranian@hpl.hp.com
Subject: Re: [PATCH 02/22] 2.6.22-rc3 perfmon2 : generic kernel
 modifications
Message-Id: <20070530234206.ae2bec8d.sfr@canb.auug.org.au>
In-Reply-To: <20070530113403.GA14480@lnx-holt.americas.sgi.com>
References: <200705291348.l4TDmG1Y019632@frankl.hpl.hp.com>
	<20070530004658.732451ad.sfr@canb.auug.org.au>
	<20070530113403.GA14480@lnx-holt.americas.sgi.com>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_May_2007_23_42_06_+1000_P_LUyEnTrVg9vE+L"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_May_2007_23_42_06_+1000_P_LUyEnTrVg9vE+L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 30 May 2007 06:34:03 -0500 Robin Holt <holt@sgi.com> wrote:
>
> That breaks git-bisect.  Just introducing new text, but not actually using
> it makes it appear to somebody using git-bisect to identify the source of
> a problem as though all the changes came in at the same time.  Bad idea.

But the patch set as it is includes references to files that do not exist
and so breaks the build.

Ideally, you would introduce references to files as the files are
introduced. I was suggesting a simpler reordering of the patches.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_May_2007_23_42_06_+1000_P_LUyEnTrVg9vE+L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGXX8zFdBgD/zoJvwRAgyBAJ9n8ac60GPY//eSofi7+azhuRgNMwCeKDvt
GZhRcxIagZvq6i8svrQAqr4=
=+dWX
-----END PGP SIGNATURE-----

--Signature=_Wed__30_May_2007_23_42_06_+1000_P_LUyEnTrVg9vE+L--
