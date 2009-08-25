Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZHYA5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZHYA5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 20:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZHYA5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 20:57:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42570 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbZHYA5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 20:57:13 -0400
Date: Tue, 25 Aug 2009 10:57:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-bluetooth@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: Re: Fw: Build failure on linux-next master branch
Message-Id: <20090825105711.b9d85e89.sfr@canb.auug.org.au>
In-Reply-To: <1251157115.2950.85.camel@localhost.localdomain>
References: <20090825093707.13bf8c49.sfr@canb.auug.org.au>
	<1251157115.2950.85.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_Aug_2009_10_57_11_+1000_KwZTcKVfDjr623ED"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Aug_2009_10_57_11_+1000_KwZTcKVfDjr623ED
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

On Mon, 24 Aug 2009 16:38:35 -0700 Marcel Holtmann <marcel@holtmann.org> wr=
ote:
>
> just pushed a fix from Randy to bluetooth-next-2.6 tree. The
> CONFIG_L2CAP was missing a select CRC16.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Aug_2009_10_57_11_+1000_KwZTcKVfDjr623ED
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqTNucACgkQjjKRsyhoI8y+PQCfQKsHY2vAnRMLyZNfY8d1qOE/
ZgcAn10sj6wuhACXwyIctocxkjFSAJ/G
=xdXg
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Aug_2009_10_57_11_+1000_KwZTcKVfDjr623ED--
