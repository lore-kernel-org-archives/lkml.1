Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbZKLIOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbZKLIOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZKLIOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:14:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47073 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbZKLIOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:14:50 -0500
Date: Thu, 12 Nov 2009 19:14:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: sysctl tree build failure
Message-Id: <20091112191451.d21250f2.sfr@canb.auug.org.au>
In-Reply-To: <m1ljicp3l0.fsf@fess.ebiederm.org>
References: <20091112184805.1c0720cb.sfr@canb.auug.org.au>
	<m1ljicp3l0.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Nov_2009_19_14_51_+1100_PcV3.W.WdM3c97PA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Nov_2009_19_14_51_+1100_PcV3.W.WdM3c97PA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Thu, 12 Nov 2009 00:08:59 -0800 ebiederm@xmission.com (Eric W. Biederman=
) wrote:
>
> Thank you, and my apologies.  I thought I had tried it with every
> applicable compile option but apparently not.
>=20
> Ugh.  It looks like I have a small refcount leak in that case as
> well.  Blind I was.
>=20
> Thank you very I will have this fixed shortly.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Nov_2009_19_14_51_+1100_PcV3.W.WdM3c97PA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr7w/sACgkQjjKRsyhoI8z9JgCfQ+l25S9stVvfUJxGCPgZadnW
uOwAniLl9+cYUIkoqo17d8xjtK0TON8m
=Lv8w
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Nov_2009_19_14_51_+1100_PcV3.W.WdM3c97PA--
