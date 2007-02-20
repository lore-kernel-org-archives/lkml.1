Return-Path: <linux-kernel-owner+w=401wt.eu-S965792AbXBTAqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965792AbXBTAqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965788AbXBTAqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:46:49 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48017 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965792AbXBTAqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:46:48 -0500
Date: Tue, 20 Feb 2007 11:47:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/char/hvc_console.c: cleanups
Message-Id: <20070220114713.c86ad072.sfr@canb.auug.org.au>
In-Reply-To: <20070220000207.GX13958@stusta.de>
References: <20070220000207.GX13958@stusta.de>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__20_Feb_2007_11_47_13_+1100_jkXk6uuXk1TDLt85"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Feb_2007_11_47_13_+1100_jkXk6uuXk1TDLt85
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 20 Feb 2007 01:02:07 +0100 Adrian Bunk <bunk@stusta.de> wrote:
>
> This patch contains the following cleanups:
> - make needlessly global code static
> - remove the unused EXPORT_SYMBOL's
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Feb_2007_11_47_13_+1100_jkXk6uuXk1TDLt85
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF2kUWFdBgD/zoJvwRAsKXAKCKwfdBMHNhVpu2hPXluzE+Qxkr+gCeOUGQ
FhrMCnfKuFnv3sBU6zarsOY=
=85Ck
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Feb_2007_11_47_13_+1100_jkXk6uuXk1TDLt85--
