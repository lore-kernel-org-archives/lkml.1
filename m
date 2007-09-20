Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbXITTJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbXITTJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbXITTJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:09:29 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40670 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbXITTJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:09:28 -0400
X-Sasl-enc: lzNM3C7z1N1QiupOywnmeoRfLO6BzWdhIr+QItq0QFaf 1190315367
Message-ID: <46F2C59E.9040200@imap.cc>
Date: Thu, 20 Sep 2007 21:10:22 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: 2.6.23-rc6-mm1
References: <20070918011841.2381bd93.akpm@linux-foundation.org>	<46F1AA6E.1030708@imap.cc> <20070919162438.7264f06c.akpm@linux-foundation.org> <46F1B097.9020109@redhat.com> <46F1B706.70304@imap.cc>
In-Reply-To: <46F1B706.70304@imap.cc>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFE2FCD4FEB220D898D8B1CB8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFE2FCD4FEB220D898D8B1CB8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2007-09-20 01:55, /me wrote:
> Rats. Sorry. I remember now. That's not the first time I am hit by
> that one. I had even made a resolution to try and find out the correct
> options to set. So what are they? CONFIG_RTC=3Dy and CONFIG_RTC_DRV_CMO=
S=3Dn?
> Guess I should try that combination in my next round of tests.

Did that now. It does get rid of the
"Duplicate file names "rtc" detected."
message. The other problems remain.

> So are all my other woes a consequence of that one?

Apparently not.

> Thanks,
> T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigFE2FCD4FEB220D898D8B1CB8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG8sWmMdB4Whm86/kRAhufAJ9d+rfy6Z09pg3CQ0/Phi/c4a+yxACaAgK7
vE9DnfJgfuZJW5nu0mNXZWY=
=aTIQ
-----END PGP SIGNATURE-----

--------------enigFE2FCD4FEB220D898D8B1CB8--
