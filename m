Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157Ab0AEDkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0AEDkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 22:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472Ab0AEDkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 22:40:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37202 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab0AEDkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 22:40:01 -0500
Date: Tue, 5 Jan 2010 14:39:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thiago Farina <tfransosi@gmail.com>
Subject: Re: linux-next: tip tree build failure
Message-Id: <20100105143955.c0611580.sfr@canb.auug.org.au>
In-Reply-To: <20100104163159.GD23652@elte.hu>
References: <20100104235931.abcf2bc5.sfr@canb.auug.org.au>
	<20100104163159.GD23652@elte.hu>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Jan_2010_14_39_55_+1100_21eIcdxxJb8sgrMC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Jan_2010_14_39_55_+1100_21eIcdxxJb8sgrMC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Mon, 4 Jan 2010 17:32:00 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
>=20
> Thanks - apparently CALLER_ADDR0 isnt generally available. I've reverted =
this=20
> patch for now.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Jan_2010_14_39_55_+1100_21eIcdxxJb8sgrMC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktCtIsACgkQjjKRsyhoI8zwNwCfWL345agKo7+/q1OXBuoc8EGJ
GB8AoL9UTN2j01JDcwf1EN8/T9FuK3DS
=zWSz
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Jan_2010_14_39_55_+1100_21eIcdxxJb8sgrMC--
