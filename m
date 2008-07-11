Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYGKFEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYGKFEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYGKFD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:03:56 -0400
Received: from mx30.mail.ru ([194.67.23.238]:19886 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbYGKFD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:03:56 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: All 2.6.26-rcX hang immediately after loading ohci_hcd
Date: Fri, 11 Jul 2008 09:03:39 +0400
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0807061237200.29191-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807061237200.29191-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2805458.jLjDgP3NQu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200807110903.48500.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2805458.jLjDgP3NQu
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 06 July 2008, Alan Stern wrote:
> There doesn't seem to be much choice.
>=20
> As I recall, the consequences of leaving the old code were that=20
> sometimes a suspend or a resume wouldn't work as expected.  That's=20
> better than hanging the entire system -- but on the other hand, it=20
> would affect more people.
>=20
> Andrey, when you have time I'd like to do some more debugging to find=20
> out exactly what's going wrong.
>

Let me know what you need. I am still running rc8 but may update if needed.

--nextPart2805458.jLjDgP3NQu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkh26a4ACgkQR6LMutpd94xhiACePSw/7+qE+koWGHOcMqiOW6T6
ARwAn2CNQFIAmrYQyBDv4n8DxXcHzvYf
=GL7M
-----END PGP SIGNATURE-----

--nextPart2805458.jLjDgP3NQu--
