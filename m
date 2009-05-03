Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZECLJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZECLJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 07:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbZECLJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 07:09:03 -0400
Received: from jack.hrz.tu-chemnitz.de ([134.109.132.46]:59087 "EHLO
	jack.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbZECLJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 07:09:00 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Specific support for Intel Atom architecture
Date: Sun, 3 May 2009 13:08:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-atom; KDE/4.2.2; i686; ; )
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <200904301408.09370.tobias.doerffel@gmail.com> <20090503053821.GI570@1wt.eu> <49FD3E56.3010803@zytor.com>
In-Reply-To: <49FD3E56.3010803@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1901465.jMi2Sz0dnP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905031308.51316.tobias.doerffel@gmail.com>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: b5370707b4ebf2bad03fb23b0b024719
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1901465.jMi2Sz0dnP
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Sonntag, 3. Mai 2009 08:48:54 schrieb H. Peter Anvin:
> Willy Tarreau wrote:
> >> $(call cc-option,-march=atom,-march=i686)
> >
> > if it's an in-order architecture, wouldn't it be better to tune for i386
> > or i486 instead ?
>
> Possibly.  It would be worth measuring.
How would one do that (never benchmarked kernel stuff before)?

Regards,

Tobias


--nextPart1901465.jMi2Sz0dnP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn9ez4ACgkQHsjdpw2Oaad0vwCeI4fBJep9hcI8pYUK/j00PG5e
gtgAoKonHLSX73z4lPVxPZD4JrQpO7j/
=e2y/
-----END PGP SIGNATURE-----

--nextPart1901465.jMi2Sz0dnP--
