Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbXF1L1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbXF1L1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760051AbXF1L1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:27:37 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:48093 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327AbXF1L1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:27:36 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Richard Hughes <hughsient@gmail.com>
Subject: Re: Add INPUT support to toshiba_acpi
Date: Thu, 28 Jun 2007 13:27:21 +0200
User-Agent: KMail/1.9.7
Cc: John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bastien Nocera <hadess@hadess.net>
References: <1180614979.2693.26.camel@localhost.localdomain> <200706260703.22994.eike-kernel@sf-tec.de> <1182848195.2335.0.camel@work>
In-Reply-To: <1182848195.2335.0.camel@work>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1303352.hcWxgIIjnn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706281327.29962.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1303352.hcWxgIIjnn
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Richard Hughes wrote:
> On Tue, 2007-06-26 at 07:03 +0200, Rolf Eike Beer wrote:
>> Richard Hughes wrote:
>>> On Sat, 2007-06-23 at 16:56 +0200, Rolf Eike Beer wrote:
>>>> None of the above keys generated a key event. Neither does
>>>> "Brightness down", but it still works. "Brightness up" generates an ev=
ent
>>>> and works.
>>
>>>> Kpowersave tells me it can't do brightness switching in software
>>>> (which works in WinXtraPain).
>>
>> Yes, I need a special process running for this. Would it be of some
>> use if I take a look with IRPtracker on it or is that all you need to
>> know?
>
> Yes, although this is out of my area or expertise, sorry.

I've looked a bit but can't find any driver interaction of those programs. =
Any=20
further ideas welcome.

Eike

--nextPart1303352.hcWxgIIjnn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGg5shXKSJPmm5/E4RAhAjAKCLxeHcxmfOxAe9Gp+/4LpiDWKBtgCcCNUP
lkB5X4zHPHcnuqI3uPZpwyQ=
=avti
-----END PGP SIGNATURE-----

--nextPart1303352.hcWxgIIjnn--
