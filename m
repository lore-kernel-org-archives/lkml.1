Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZFCEmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZFCEmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZFCEmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:42:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48849 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbZFCEmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:42:42 -0400
Date: Wed, 3 Jun 2009 14:42:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       Matthew Garrett <mjg@redhat.com>
Subject: Re: linux-next: manual merge of the wireless tree with the acpi
 tree
Message-Id: <20090603144237.11999b8c.sfr@canb.auug.org.au>
In-Reply-To: <20090603030541.GC28009@srcf.ucam.org>
References: <20090603122724.ddf679ba.sfr@canb.auug.org.au>
	<20090603030541.GC28009@srcf.ucam.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Jun_2009_14_42_37_+1000_p_qyn3=W16z3VlF8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jun_2009_14_42_37_+1000_p_qyn3=W16z3VlF8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Jun 2009 04:05:41 +0100 Matthew Garrett <mjg@redhat.com> wrote:
>
> Easiest in this case might be to drop the toshiba-acpi patches from me=20
> from acpi-test for the moment - I'm still waiting for some testing=20
> feedback on them. I can rebase against the rfkill code as long as it=20
> lands early enough.

Len?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Jun_2009_14_42_37_+1000_p_qyn3=W16z3VlF8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkol/z0ACgkQjjKRsyhoI8xANgCeOLhpQtd4m6ACZiCfdIjFGFst
v1QAoKVJb3FiXudCez0zvgxrmSSuRcft
=TwS5
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jun_2009_14_42_37_+1000_p_qyn3=W16z3VlF8--
