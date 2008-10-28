Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbYJ1DUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbYJ1DUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 23:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYJ1DTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 23:19:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:45091 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751865AbYJ1DTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 23:19:54 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX1+miwA1l7Sm7/0PgYcEQlS9ig7TMriUUpwyJceCLB
	8QLnJp1ukgZG0e
Date: Tue, 28 Oct 2008 04:19:41 +0100
From: Mirco Tischler <mt-ml@gmx.de>
To: Zhu Yi <yi.zhu@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
Message-ID: <20081028041941.6e5d6583@mtlp.12.dimension>
In-Reply-To: <1225160390.2917.221.camel@debian.sh.intel.com>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	<1225157618.2917.215.camel@debian.sh.intel.com>
	<20081028025947.6c9c3274@mtlp.12.dimension>
	<1225160390.2917.221.camel@debian.sh.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/A5NiPveinrknEboQ6qqaWpt";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/A5NiPveinrknEboQ6qqaWpt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2008 10:19:50 +0800, Zhu Yi wrote:
> You don't need this command if wpa_supplicant works correctly. Is it a
> hidden SSID AP?
No it isn't. Did I mention it worked well with 2.6.27?
> Thanks,
> -yi

--Sig_/A5NiPveinrknEboQ6qqaWpt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkGhNcACgkQz+diZ7c2xfhatgCfRh5RF0kGlEowz2guEhsp72dk
EZ4AoIY6LE/GQ5a6AgoUWKkwS3hw/gMX
=QzL9
-----END PGP SIGNATURE-----

--Sig_/A5NiPveinrknEboQ6qqaWpt--
