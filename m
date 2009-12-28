Return-Path: <linux-kernel-owner+w=401wt.eu-S1751740AbZL1IBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbZL1IBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZL1IBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:01:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60483 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbZL1IBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:01:10 -0500
Date: Mon, 28 Dec 2009 19:01:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: slab/percpu tree build failure
Message-Id: <20091228190103.afa89d66.sfr@canb.auug.org.au>
In-Reply-To: <1261986163.4641.0.camel@penberg-laptop>
References: <20091224095848.f1586d1e.sfr@canb.auug.org.au>
	<1261986163.4641.0.camel@penberg-laptop>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Dec_2009_19_01_03_+1100_/Ngapu6TrWJ/dw+v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Dec_2009_19_01_03_+1100_/Ngapu6TrWJ/dw+v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pekka,

On Mon, 28 Dec 2009 09:42:43 +0200 Pekka Enberg <penberg@cs.helsinki.fi> wr=
ote:
>
> Looks good to me, thanks! I guess you should carry it in linux-next so
> that I don't need to pull percpu.git in slab.git?

That's the plan.  Thanks for the confirmation.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Dec_2009_19_01_03_+1100_/Ngapu6TrWJ/dw+v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAks4Zb8ACgkQjjKRsyhoI8wMBQCfV/8Ym8WtbyzHQD0j+EGvaVnJ
WYAAnRBxEkwtL+gt01XMxOq0h+lO1D2n
=Gsbe
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Dec_2009_19_01_03_+1100_/Ngapu6TrWJ/dw+v--
