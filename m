Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbZELDzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbZELDzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 23:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbZELDzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 23:55:33 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34473 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945AbZELDzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 23:55:31 -0400
Message-ID: <4A08F330.6070006@novell.com>
Date: Mon, 11 May 2009 23:55:28 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Gregory Haskins <ghaskins@novell.com>, viro@ZenIV.linux.org.uk,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com> <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com> <4A024214.9090002@novell.com> <alpine.DEB.1.10.0905080805510.16601@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0905080805510.16601@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8A799D05683BD512A2AA5631"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8A799D05683BD512A2AA5631
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Wed, 6 May 2009, Gregory Haskins wrote:
>
>  =20
>> If there isn't any more feedback on the series from Al, Avi,
>> etc...please formally submit your eventfd patch so this series is
>> available for Avi to pull in for inclusion when/if he deems it fit.
>>    =20
>
> Did you decide you will be using those bits?
>  =20

Hi Davide,
  It appears that we will not end up needing them since the new version
I am about to push goes back to creating the eventfd in userspace to
begin with, per Avi's request.  Regardless, thank you kindly for your
help here, and also for your poll suggestion which we will definitely be
using.

Regards,
-Greg



--------------enig8A799D05683BD512A2AA5631
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoI8zAACgkQlOSOBdgZUxl3mACferlOZkHf8Qx1/O797wmbanvN
dB8An0rEqCIBKw/5Ocfgni2k8SeqIxPC
=J30F
-----END PGP SIGNATURE-----

--------------enig8A799D05683BD512A2AA5631--
