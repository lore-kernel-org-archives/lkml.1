Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbYIZKf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbYIZKf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYIZKft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:35:49 -0400
Received: from lax-green-bigip-5.dreamhost.com ([208.113.200.5]:44870 "EHLO
	spaceymail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751583AbYIZKfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:35:47 -0400
Message-ID: <48DCBEC3.2020904@hannent.co.uk>
Date: Fri, 26 Sep 2008 11:51:47 +0100
From: Phil Hannent <phil@hannent.co.uk>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, mwilder@cs.nmsu.edu
Subject: Re: [PATCH] Input: add mmio xi driver
References: <20080925232237.GA22938@suse.de> <20080925182055.f12f5d0b.randy.dunlap@oracle.com> <20080926031918.GA10083@suse.de>
In-Reply-To: <20080926031918.GA10083@suse.de>
X-Enigmail-Version: 0.95.7
OpenPGP: 
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig99566593677E74112CB86E6E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig99566593677E74112CB86E6E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Greg KH wrote:
> On Thu, Sep 25, 2008 at 06:20:55PM -0700, Randy Dunlap wrote:
>> On Thu, 25 Sep 2008 16:22:37 -0700 Greg KH wrote:
>>
>>> From: Greg Kroah-Hartman <gregkh@suse.de>
>>>
>>> This patch adds the Mimio Xi interactive whiteboard driver to the tre=
e.
>>>
>>> It was originally written by mwilder@cs.nmsu.edu, but cleaned up and
>>> forward ported by me to the latest kernel version.
I have been given the protocol document for the whiteboards, I am not all=
owed to
share it with anybody unfortunately.

I am just waiting for approval of funds for me to start development of th=
is
driver and an X11 library to make the ink capture work.

I expect to start work at the end of October, I could do with a mentor to=
 help
me with this.

Just so you do not get the wrong idea, I plan on sticking around to maint=
ain the
driver once its complete even if its my spare time to do so.

Regards
Phil Hannent



--------------enig99566593677E74112CB86E6E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)

iEYEAREKAAYFAkjcvsMACgkQIdVDbqU9AOTdEgCdFFBOrSfRR3RIVlBKO7Gn/HgU
akUAn3VBNy7YjHPMBm+VOVcyZffukuXD
=WqZM
-----END PGP SIGNATURE-----

--------------enig99566593677E74112CB86E6E--
