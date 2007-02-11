Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXBKSjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXBKSjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932066AbXBKSjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:39:19 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44399 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065AbXBKSjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:39:19 -0500
X-Sasl-enc: ijTC1QXkrthfHSDJYjYapbIcwT9UoUpJB2qJBu6vegJb 1171219156
Message-ID: <45CF630F.1040706@imap.cc>
Date: Sun, 11 Feb 2007 19:40:15 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Jiri Kosina <jikos@jikos.cz>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, hjlipp@web.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-Usb-Devel <linux-usb-devel@lists.sourceforge.net>
Subject: Re: gigaset build broken on current linux-2.6.git
References: <45CBA41D.3000406@garzik.org> <Pine.LNX.4.64.0702082344100.25686@twin.jikos.cz> <45CC3109.1010502@imap.cc>
In-Reply-To: <45CC3109.1010502@imap.cc>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCB3D9A17D1418B91C38F7690"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCB3D9A17D1418B91C38F7690
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 08 Feb 2007 14:02:31 +0100 I wrote:
> Subject: Re: [linux-usb-devel] [PATCH 41/70] usbcore: remove unused ban=
dwith-related code
>=20
> This breaks compilation of drivers/isdn/gigaset/bas-gigaset.c.
> If you pass on this patch, please pass on Andrew's
>=20
> fix-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
>=20
> along with it.

On Fri, 09 Feb 2007 09:30:01 +0100, I wrote:
> Jiri Kosina schrieb:
>> ISDN: gigaset - remove forgotten urb->bandwidth reference
>>
>> Recent changes in usbcore removed the bandwidth field from struct urb.=

>> Remove the forgotten occurence in bas-gigaset.c
>>
>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

I notice that 2.6.20-git6 still doesn't include either of these fixes.
Is there anything I need to do in order to push it?

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- In theory, there is no difference between theory and practice.
  In practice, there is.


--------------enigCB3D9A17D1418B91C38F7690
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFz2MQMdB4Whm86/kRAkWeAJ42nOO7xt887sK9HwnjZKsrbklZ0wCbBTHR
azs0ZLQwCNH87VyhN0m1lew=
=DnJ7
-----END PGP SIGNATURE-----

--------------enigCB3D9A17D1418B91C38F7690--
