Return-Path: <linux-kernel-owner+w=401wt.eu-S935698AbZLGW7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935698AbZLGW7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935688AbZLGW7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:59:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55913 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935663AbZLGW7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:59:35 -0500
Date: Tue, 8 Dec 2009 09:59:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Johannes Berg <johannes@sipsolutions.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: net/wireless/wireless-current tree build warning
Message-Id: <20091208095931.aaff7572.sfr@canb.auug.org.au>
In-Reply-To: <20091207223236.GF18939@tuxdriver.com>
References: <20091201133524.32756cef.sfr@canb.auug.org.au>
	<1260191754.3737.1.camel@johannes.local>
	<20091208092057.dd2eeaeb.sfr@canb.auug.org.au>
	<20091207223236.GF18939@tuxdriver.com>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Dec_2009_09_59_31_+1100_EbaWyJP+hy3gae=z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Dec_2009_09_59_31_+1100_EbaWyJP+hy3gae=z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Mon, 7 Dec 2009 17:32:37 -0500 "John W. Linville" <linville@tuxdriver.co=
m> wrote:
>
> I've just merged such a patch...thanks!

Ah, thanks.  I will still apply it as a merge fix for the net tree until
Dave merges your tree again.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Dec_2009_09_59_31_+1100_EbaWyJP+hy3gae=z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksdiNMACgkQjjKRsyhoI8yAfQCePZCiC4ou/eaeUZw9jUmeTzWd
w9MAnjY+hADa4JDWeILQ140jrwWoL9j+
=mhef
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Dec_2009_09_59_31_+1100_EbaWyJP+hy3gae=z--
