Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbZFUPyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbZFUPyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 11:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZFUPyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 11:54:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43551 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZFUPyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 11:54:32 -0400
Date: Mon, 22 Jun 2009 01:54:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfi-devel@simplefirmware.org, x86@kernel.org
Subject: Re: linux-next: Tree for June 19
Message-Id: <20090622015427.c749a0d9.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.0906201415400.4083@localhost.localdomain>
References: <20090619172622.05adb236.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.0906200012200.4325@localhost.localdomain>
	<20090620150433.4e038676.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.0906201415400.4083@localhost.localdomain>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Jun_2009_01_54_27_+1000_uK3yB0fj3S/2fR0z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Jun_2009_01_54_27_+1000_uK3yB0fj3S/2fR0z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Sat, 20 Jun 2009 14:27:59 -0400 (EDT) Len Brown <lenb@kernel.org> wrote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >=20
> > Is this 2.6.31 or 32 material?
>=20
> yes:-)
>=20
> Most that is in in sfi-test at this moment I hope to catch .31.
> There will be much more in .32 -- mostly things that depend on
> the first batch...

OK, so then don't add any (more) .32 material into that branch until
after Linus' releases 31-rc1, please.

> > Should I put just you as the contact, or add the mailing list as well?
>=20
> The mailing list is fine (on cc), and I'm on that.
> It is redundant to send to both.

Then please ensure that I can post to that list (I don't want to
subscribe obviously).

> > Basically, this should be just what you would send to Linus (or ask him
> > to fetch).  It is allowed to be rebased if you deem it necessary.
>=20
> The patches are tested on the pre-release platform that
> makes use of them.  There have been several internal reviews
> and re-writes, but since we just got permission to release the
> patches last week, they've not been publically vetted yet.
>=20
> The content is quite close to what I plan to propose for upstream,
> but the format is not.  I'll be re-factoring the series into
> "clean history" and senting them to LKML on Sunday night.
>=20
> I don't expect much comment on the generic part,
> but will want x86 maintainers to buy into the
> parts that touch their architecture.

OK, then I think I need to hear from the x86 maintainers, at least,
before we include this.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Jun_2009_01_54_27_+1000_uK3yB0fj3S/2fR0z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko+V7MACgkQjjKRsyhoI8y4FwCcDpNw+ZeN0NZJAmuifd+9WB5W
FdkAoLqQAWjbZzE6jenESGJf40kDZdZT
=1Z66
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Jun_2009_01_54_27_+1000_uK3yB0fj3S/2fR0z--
