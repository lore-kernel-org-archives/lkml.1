Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbYJVHan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbYJVHan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYJVHa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:30:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44631 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbYJVHaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:30:24 -0400
Date: Wed, 22 Oct 2008 18:30:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Sending patches, against linux-next.git, linux-2.6.git or what?
Message-Id: <20081022183014.c3b39a64.sfr@canb.auug.org.au>
In-Reply-To: <48FEAD30.3090906@lougher.demon.co.uk>
References: <48FEAD30.3090906@lougher.demon.co.uk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__22_Oct_2008_18_30_14_+1100_uPXdK6GzvSbQFKky"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Oct_2008_18_30_14_+1100_uPXdK6GzvSbQFKky
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Phillip,

On Wed, 22 Oct 2008 05:33:52 +0100 Phillip Lougher <phillip@lougher.demon.c=
o.uk> wrote:
>
> I'm about to send another respin of the Squashfs patches.  Do I base=20
> them against linux-next.git, linux-2.6.git or what?  I thought they=20
> should be against linux-next, but I've already got one complaint.  So,=20
> I'm confused, what tree should new patches be based off?

Please base your patches on Linus' current git tree.  linux-next is too
much of a moving target.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__22_Oct_2008_18_30_14_+1100_uPXdK6GzvSbQFKky
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj+1oYACgkQjjKRsyhoI8wBYQCdHFZmjQdx2sNY/mZzXAWAuEvK
IlsAnRkMcaY8mZ0UEsk1hfeparIFduOP
=nl5G
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Oct_2008_18_30_14_+1100_uPXdK6GzvSbQFKky--
