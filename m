Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZIPPtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZIPPtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZIPPtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:49:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44677 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbZIPPtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:49:04 -0400
Date: Thu, 17 Sep 2009 01:49:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] edac: need to export cpu_llc_id
Message-Id: <20090917014901.1011949d.sfr@canb.auug.org.au>
In-Reply-To: <20090916044151.GB5767@aftab>
References: <20090916093935.6bc2c91f.sfr@canb.auug.org.au>
	<20090916044151.GB5767@aftab>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Sep_2009_01_49_01_+1000_nxRBRWLHZDa6lNS2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Sep_2009_01_49_01_+1000_nxRBRWLHZDa6lNS2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boris,

On Wed, 16 Sep 2009 06:41:51 +0200 Borislav Petkov <borislav.petkov@amd.com=
> wrote:
>
> proper fix is at http://marc.info/?l=3Dlinux-kernel&m=3D125302459621925

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Sep_2009_01_49_01_+1000_nxRBRWLHZDa6lNS2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqxCO0ACgkQjjKRsyhoI8wGZACeNGTizmlI1xcIH8QXLcXKOGMN
eIMAn10d6UKh1uaUOj2ffodI0FRs4iBq
=h7Ni
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Sep_2009_01_49_01_+1000_nxRBRWLHZDa6lNS2--
