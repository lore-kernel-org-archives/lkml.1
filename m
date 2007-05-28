Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbXE1Ako@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbXE1Ako (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 20:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbXE1Ake
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 20:40:34 -0400
Received: from daemonizer.de ([87.230.16.230]:54014 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbXE1Akd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 20:40:33 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Mon, 28 May 2007 02:40:11 +0200
User-Agent: KMail/1.9.7
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705280016.02776.maxi@daemonizer.de> <200705280224.40506.mb@bu3sch.de>
In-Reply-To: <200705280224.40506.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6684804.BsDE7AEg01";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705280240.17910.maxi@daemonizer.de>
X-Spam-Score: -4.1 (----)
X-Spam-Report: No, hits=-4.1 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.3 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6684804.BsDE7AEg01
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 28 May 2007, Michael Buesch wrote:
> Ok, another question: On which CPU architecture are you?

maxi@koala:~$ uname -m
i686

Maxi

--nextPart6684804.BsDE7AEg01
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWiTxOimwv528XGERAvPhAJ9oPMPnshRNvGWpaAqHSA0P64lmlACgrNel
rGF3jBGRM8rRU0Ui/fNUmKA=
=i7rZ
-----END PGP SIGNATURE-----

--nextPart6684804.BsDE7AEg01--
