Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbZHXIXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbZHXIXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZHXIXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:23:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46542 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZHXIXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:23:21 -0400
Date: Mon, 24 Aug 2009 18:23:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: manual merge of the tip tree with the s390 tree
Message-Id: <20090824182315.85210a5a.sfr@canb.auug.org.au>
In-Reply-To: <20090824081723.GA4798@osiris.boeblingen.de.ibm.com>
References: <20090824170119.57cf4f59.sfr@canb.auug.org.au>
	<20090824081723.GA4798@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_Aug_2009_18_23_15_+1000_nDPVFqBMXYOraf3k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Aug_2009_18_23_15_+1000_nDPVFqBMXYOraf3k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Heiko,

On Mon, 24 Aug 2009 10:17:23 +0200 Heiko Carstens <heiko.carstens@de.ibm.co=
m> wrote:
>
> I reverted the sched_clock_base_cc rename. The merge conflict
> should be gone as soon as Martin pushes a new tree out.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_Aug_2009_18_23_15_+1000_nDPVFqBMXYOraf3k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqSTfMACgkQjjKRsyhoI8zofQCfQhwrvL31IUVFhHuvSAYPXLsB
c2oAn0ArVaTbygXqZrvwdD6iCWFiVvoP
=Ofpg
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Aug_2009_18_23_15_+1000_nDPVFqBMXYOraf3k--
