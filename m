Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbXKBIht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbXKBIht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 04:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXKBIhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 04:37:42 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:35700 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbXKBIhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 04:37:41 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: lenb@kernel.org
Subject: Re: [2.6.24-rc1][BUG] Oops on battery removal
Date: Fri, 2 Nov 2007 09:37:33 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-acpi@vger.kernel.org, astarikovskiy@suse.de,
       kernel list <linux-kernel@vger.kernel.org>
References: <200711020803.49608.eike-kernel@sf-tec.de>
In-Reply-To: <200711020803.49608.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6457516.6vRJRSPn98";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711020937.33672.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6457516.6vRJRSPn98
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Rolf Eike Beer wrote:
> Hi,
>
> this happened while I removed my battery on bootup. Complete dmesg is
> attached. Kernel is 2.6.24-rc1-git of yesterday (last commit was
> d919fd433b5823d1cf9d0688eb2eec183de9b74c).

Ok, I found out that it has nothing to do with the actual removal as it see=
ms.=20
When I start the laptop with battery already detached I get the same error.

Eike

--nextPart6457516.6vRJRSPn98
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHKuHNXKSJPmm5/E4RAsGkAKCPJsedt8FGTavlgecZX41cw3IMxwCgne5x
gIaxpyVhVZXGY95RGXVwihM=
=gx7D
-----END PGP SIGNATURE-----

--nextPart6457516.6vRJRSPn98--
