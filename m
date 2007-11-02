Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbXKBN0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbXKBN0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbXKBN0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:26:46 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:57687 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbXKBN0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:26:45 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [2.6.24-rc1][BUG] Oops on battery removal
Date: Fri, 2 Nov 2007 14:26:40 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <200711020803.49608.eike-kernel@sf-tec.de> <200711021250.03555.eike-kernel@sf-tec.de> <472B1F53.5080902@suse.de>
In-Reply-To: <472B1F53.5080902@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1403349.ezhppFNXXx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711021426.40728.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1403349.ezhppFNXXx
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Alexey Starikovskiy wrote:
> Rolf Eike Beer wrote:
> > Alexey Starikovskiy wrote:
> >> Rolf Eike Beer wrote:
> >>> Rolf Eike Beer wrote:
> >>>> Hi,
> >>>>
> >>>> this happened while I removed my battery on bootup. Complete dmesg is
> >>>> attached. Kernel is 2.6.24-rc1-git of yesterday (last commit was
> >>>> d919fd433b5823d1cf9d0688eb2eec183de9b74c).
> >>>
> >>> Ok, I found out that it has nothing to do with the actual removal as it
> >>> seems. When I start the laptop with battery already detached I get the
> >>> same error.
> >>
> >> Please check if this patch helps.
> >
> > It made things worse:
>
> How about this patch?

Ehm, that is the same patch as before!

Btw: it has an empty From: line

Eike

--nextPart1403349.ezhppFNXXx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHKyWQXKSJPmm5/E4RAiihAJ9CcFxF6eiD96ytMRkqTCPdTG18nACfYqGm
rRLhKx/Zam2tY3x8uovp2ZU=
=lelq
-----END PGP SIGNATURE-----

--nextPart1403349.ezhppFNXXx--
