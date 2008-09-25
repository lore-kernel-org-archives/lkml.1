Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYIYLbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYIYLbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYIYLaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:30:55 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:41937 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbYIYLay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:30:54 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Date: Thu, 25 Sep 2008 13:30:40 +0200
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4305458.UIFvjaWf2G";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809251330.43471.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4305458.UIFvjaWf2G
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Yinghai Lu wrote:
> v2: fix hpet compiling

Are you sure you sent the right patch? It only adds some printk()'s and=20
unrelated newlines.

Eike

--nextPart4305458.UIFvjaWf2G
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjbdmMACgkQXKSJPmm5/E62cgCfdrUzsWQYYllJ2H5bKBO4soiY
FOMAmgONRLVUmuiIV8k4QZqg1rFm5K+x
=0Ndx
-----END PGP SIGNATURE-----

--nextPart4305458.UIFvjaWf2G--
