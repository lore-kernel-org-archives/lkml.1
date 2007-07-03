Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbXGCFzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbXGCFzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbXGCFzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:55:19 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:50232 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbXGCFzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:55:18 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Subject: Re: Add INPUT support to toshiba_acpi
Date: Tue, 3 Jul 2007 07:38:34 +0200
User-Agent: KMail/1.9.7
Cc: Richard Hughes <hughsient@gmail.com>, John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bastien Nocera <hadess@hadess.net>, Mathieu.Berard@crans.org
References: <1180614979.2693.26.camel@localhost.localdomain> <200706281327.29962.eike-kernel@sf-tec.de> <4683A80E.4070006@mandic.com.br>
In-Reply-To: <4683A80E.4070006@mandic.com.br>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9037258.MZ5o41Lbe6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707030738.39980.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9037258.MZ5o41Lbe6
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Renato S. Yamane wrote:
> Rolf Eike Beer wrote:
> > Richard Hughes wrote:
> >> Yes, although this is out of my area or expertise, sorry.
> >
> > I've looked a bit but can't find any driver interaction of those
> > programs. Any further ideas welcome.
>
> Do you try omnibook driver?
> svn export https://svn.sourceforge.net/svnroot/omnibook/omnibook/trunk
>
> toshiba_acpi don't work on my Toshiba M45-S355 (Toshiba BIOS) and I try
> this module above and now I can change brightness writing in
> /proc/omnibook/lcd and kpowersave can change brightness too.
>
> But, is impossible use multimedia keys (play, pause, browser, etc) and
> couple keys (fn-fx), because Fn key and Multimedia keys don't is
> recognized.

Oh wow! Even my Multimedia keys get recognized. Thanks very much for your=20
pointer.

Eike

--nextPart9037258.MZ5o41Lbe6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGieDfXKSJPmm5/E4RArIHAJ0TIxNDBoJa3BF27psfUUuz9g7/gACgjlq/
2J5E8rLntBTClsJGWyMuSwQ=
=+1eI
-----END PGP SIGNATURE-----

--nextPart9037258.MZ5o41Lbe6--
