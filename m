Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab0BLM0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 07:26:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52371 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab0BLM0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:26:04 -0500
Date: Fri, 12 Feb 2010 23:25:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: linux-next: build warning after merge of the suspend tree
Message-Id: <20100212232554.4a3b065a.sfr@canb.auug.org.au>
In-Reply-To: <201002121232.45343.rjw@sisk.pl>
References: <20100212155750.3f95932f.sfr@canb.auug.org.au>
	<201002121232.45343.rjw@sisk.pl>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Feb_2010_23_25_54_+1100_ZEdxd.CNetRwUV0m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Feb_2010_23_25_54_+1100_ZEdxd.CNetRwUV0m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

On Fri, 12 Feb 2010 12:32:45 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> Ah, missing "void", sorry about that.  Should be fixed now.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Feb_2010_23_25_54_+1100_ZEdxd.CNetRwUV0m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt1SNIACgkQjjKRsyhoI8xLegCgpuXf1ExdsKzl6dji+8c0jMEI
Ak4AniIXhqORrcDuyf4Gln9rtDnZ2EHK
=B1/K
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Feb_2010_23_25_54_+1100_ZEdxd.CNetRwUV0m--
