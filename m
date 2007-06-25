Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbXFYLDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbXFYLDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 07:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXFYLDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 07:03:34 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:53992 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbXFYLDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 07:03:33 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Richard Hughes <hughsient@gmail.com>
Subject: Re: Add INPUT support to toshiba_acpi
Date: Mon, 25 Jun 2007 13:03:38 +0200
User-Agent: KMail/1.9.7
Cc: John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bastien Nocera <hadess@hadess.net>
References: <1180614979.2693.26.camel@localhost.localdomain> <200706231656.39597.eike-kernel@sf-tec.de> <1182765156.2519.0.camel@work>
In-Reply-To: <1182765156.2519.0.camel@work>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1519661.JvPYJ4N3vj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706251303.47652.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1519661.JvPYJ4N3vj
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Richard Hughes wrote:
> On Sat, 2007-06-23 at 16:56 +0200, Rolf Eike Beer wrote:
> > None of the above keys generated a key event. Neither does "Brightness
> > down", but it still works. "Brightness up" generates an event and works.
> > Kpowersave tells me it can't do brightness switching in software (which
> > works in WinXtraPain).
>
> Do you know how windows does this? Do you have to load a special
> system-try thing to make the keys work?

I'll have a look once I find time to boot Windows.

Eike

--nextPart1519661.JvPYJ4N3vj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGf6ETXKSJPmm5/E4RAsXUAKCQ+l+LO4tPfhU+WgPVbqx828NSXgCdHWVT
BIEDo46KH72aH7FjiCJ+dCM=
=ABkB
-----END PGP SIGNATURE-----

--nextPart1519661.JvPYJ4N3vj--
