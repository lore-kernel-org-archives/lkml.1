Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZGGENx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZGGENx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 00:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbZGGENp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 00:13:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56168 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZGGENo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 00:13:44 -0400
Date: Tue, 7 Jul 2009 14:13:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: sfi tree build failure
Message-Id: <20090707141325.35b93b3a.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.0907062348130.32467@localhost.localdomain>
References: <20090630171937.75f64662.sfr@canb.auug.org.au>
	<20090706161432.111a42ee.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.0907062348130.32467@localhost.localdomain>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Jul_2009_14_13_25_+1000_BXO3UBWHQlGSR_oZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jul_2009_14_13_25_+1000_BXO3UBWHQlGSR_oZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Tue, 07 Jul 2009 00:01:13 -0400 (EDT) Len Brown <lenb@kernel.org> wrote:
>
> I screwed up in my hack attempt to support CONFIG_SFI=3Dy && CONFIG_ACPI=
=3Dn.

Yeah, I figured something like that.

> Let me know if you have any trouble with the latest SFI test tree.

I have refetched the sfi tree (as I had not merged it yet today).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Jul_2009_14_13_25_+1000_BXO3UBWHQlGSR_oZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpSy2UACgkQjjKRsyhoI8wERwCfdR73JASnx1bwpysjY71qcP3z
q6cAoL0DkVUNTnGhY+13Ca3Hon1bwNnw
=R4fh
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jul_2009_14_13_25_+1000_BXO3UBWHQlGSR_oZ--
