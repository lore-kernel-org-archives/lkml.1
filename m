Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbZIWMu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbZIWMu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZIWMu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:50:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43303 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbZIWMu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:50:27 -0400
Date: Wed, 23 Sep 2009 22:50:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>
Subject: Re: linux-next: manual merge of the usb tree with Linus' tree
Message-Id: <20090923225026.c03c84c6.sfr@canb.auug.org.au>
In-Reply-To: <4ABA16BF.4020504@windriver.com>
References: <20090923163817.44bcebb8.sfr@canb.auug.org.au>
	<4ABA16BF.4020504@windriver.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Sep_2009_22_50_26_+1000_THN2bTq4jdpYtd.K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Sep_2009_22_50_26_+1000_THN2bTq4jdpYtd.K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Wed, 23 Sep 2009 07:38:23 -0500 Jason Wessel <jason.wessel@windriver.com=
> wrote:
>
> Please, let me know if there is something I need to do here.
>=20
> Simply changing the context of the patch in Greg's branch should be
> enough.   There are many more fixes beyond just the timing loop in the
> dbgp series which cover, cold and warm restarts and various errata with
> the ehci debug controllers.

Yeah, I think Greg just needs to rebase his series on to a more recent
version of Linus' tree.  (and then test and submit it, of course :-))

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Sep_2009_22_50_26_+1000_THN2bTq4jdpYtd.K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkq6GZIACgkQjjKRsyhoI8zl5gCdGTVlxqiCHDEmc32sxSsNX3ic
AMEAoIIKcfnGEDsMup+yu9aS/xbuNQNx
=saFG
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Sep_2009_22_50_26_+1000_THN2bTq4jdpYtd.K--
