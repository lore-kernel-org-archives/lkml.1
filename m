Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbYFWXrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbYFWXrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYFWXrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:47:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52873 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbYFWXrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:47:13 -0400
Date: Tue, 24 Jun 2008 09:47:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] m68knommu: ColdFire add support for kernel preemption
Message-Id: <20080624094706.56c8526f.sfr@canb.auug.org.au>
In-Reply-To: <485FA3BC.5080807@snapgear.com>
References: <200805010216.m412GT6t004096@goober>
	<20080501143336.552e39e1.akpm@linux-foundation.org>
	<481AC07A.6080707@snapgear.com>
	<20080502083755.GA13973@Chamillionaire.breakpoint.cc>
	<20080502052235.eb9c336a.akpm@linux-foundation.org>
	<485F3585.2080606@snapgear.com>
	<20080622225102.5117f22b.akpm@linux-foundation.org>
	<20080623175326.ddf5d2d4.sfr@canb.auug.org.au>
	<485FA3BC.5080807@snapgear.com>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Jun_2008_09_47_06_+1000_PKbpDMhF7z=+3J3n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Jun_2008_09_47_06_+1000_PKbpDMhF7z=+3J3n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 23 Jun 2008 23:23:08 +1000 Greg Ungerer <gerg@snapgear.com> wrote:
>
> Ok, done too. Branches named for-next exist in both. The patches
> on the for-linus branch in the m68knommu.git are now on the
> for-next branch.

I have updated my info, thanks.

> Do I need to send a request to Linus to pull this into his
> tree during the next merge window?  Or will it migrate up
> from linux-next?

Andrew has answered these.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Jun_2008_09_47_06_+1000_PKbpDMhF7z=+3J3n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhgNfoACgkQTgG2atn1QN/02QCfe4kREggc3ufMJ56iGoj8IvcB
EkUAnRMIlaLDZ/PLSFqZAdemOKl3O44M
=v5g9
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Jun_2008_09_47_06_+1000_PKbpDMhF7z=+3J3n--
