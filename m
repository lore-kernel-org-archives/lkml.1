Return-Path: <linux-kernel-owner+w=401wt.eu-S1760934AbZENHtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbZENHtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbZENHtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:49:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58661 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbZENHtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:49:02 -0400
Date: Thu, 14 May 2009 17:48:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>, Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [PATCH 00/16] asm-generic headers, v4
Message-Id: <20090514174856.f49fac96.sfr@canb.auug.org.au>
In-Reply-To: <200905140928.01861.arnd@arndb.de>
References: <1242255398-23779-1-git-send-email-arnd@arndb.de>
	<20090514164521.c2b61893.sfr@canb.auug.org.au>
	<200905140928.01861.arnd@arndb.de>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__14_May_2009_17_48_56_+1000_He73o=JXrw+Da.y9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_May_2009_17_48_56_+1000_He73o=JXrw+Da.y9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Thu, 14 May 2009 09:28:01 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> I've tried to make this patch set as non-invasive as possible, basically
> just adding files and making single line changes to existing files
> where necessary. I've never seen conflicts when I tried merging
> with linux-next/master.

Yeah, I just did a test merge and no conflicts at all!  A test merge
against mmotm seems to get conflicts only in files not modified by your
patches.

Looks good from that point of view.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__14_May_2009_17_48_56_+1000_He73o=JXrw+Da.y9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoLzOgACgkQjjKRsyhoI8yC/wCgug97kq1eb225v6aTS6RMKzlX
gWYAoLe5MDpUiHt7lXcgMI9ql+3nitYX
=JV9z
-----END PGP SIGNATURE-----

--Signature=_Thu__14_May_2009_17_48_56_+1000_He73o=JXrw+Da.y9--
