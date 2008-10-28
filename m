Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYJ1CAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYJ1CAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 22:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYJ1CAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 22:00:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:37316 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752059AbYJ1CAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 22:00:03 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX1/9thZt6dH9vklTYMANAyjpyIIfcJeUFe3mvxrXfu
	/KORFy/w/VgwM5
Date: Tue, 28 Oct 2008 02:59:47 +0100
From: Mirco Tischler <mt-ml@gmx.de>
To: Zhu Yi <yi.zhu@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
Message-ID: <20081028025947.6c9c3274@mtlp.12.dimension>
In-Reply-To: <1225157618.2917.215.camel@debian.sh.intel.com>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	<1225157618.2917.215.camel@debian.sh.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aadVAZvxF7e5TJ8.DYXDhyE";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/aadVAZvxF7e5TJ8.DYXDhyE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2008 09:33:37 +0800, Zhu Yi wrote:
>=20
> Looks good so far. But I failed to see what are you trying to connect?
> Can you try "iwconfig wlan0 channnel <> essid <>"?
Sorry. I should have supplied that information on the first try. The networ=
k is
a standard WPA-protected G-band network at 2.437Ghz (channel 6).
That command seems to help a bit. At least I was able to connect more often
after executing it. I will observe that in detail tomorrow though.
>=20
> Does your AP work on A band?
>=20
> Thanks,
> -yi

--Sig_/aadVAZvxF7e5TJ8.DYXDhyE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkGciAACgkQz+diZ7c2xfiRfgCfT4HzEHYqupPRtNrlZay135VQ
WSgAn0ULlFWKRyt6gAD9yjfE16KDrZH9
=bl3v
-----END PGP SIGNATURE-----

--Sig_/aadVAZvxF7e5TJ8.DYXDhyE--
