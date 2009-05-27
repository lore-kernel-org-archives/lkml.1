Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbZE0UrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbZE0UrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbZE0Uqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:46:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:62441 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZE0Uqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=nuzdjQHLBt9+hhPzPv8p+rOOXZ43xgV5jjbUYPrna06NyLwwzkqJY1ELSkl9e6isVX
         rThf+Om/+jqX7e6c17e1Zum7ONmKOf+oAMkffUDmDHssdZqrsl+znBJfmQoYuVxH8eGT
         JtijGtXXaXH7sfujiLuw72NQTJE2EGLfsG9Wo=
Message-ID: <4A1DA6BC.4020104@gmail.com>
Date: Wed, 27 May 2009 16:46:52 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090527130447.GA11643@redhat.com> <4A1D48FA.9080403@novell.com> <20090527184106.GA18463@redhat.com> <4A1D9D7B.9080507@novell.com> <20090527204324.GA22915@redhat.com>
In-Reply-To: <20090527204324.GA22915@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB891F47413A56DCCF1C71CC6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB891F47413A56DCCF1C71CC6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, May 27, 2009 at 04:07:23PM -0400, Gregory Haskins wrote:
>  =20
>> Do you have a particular suggestion in mind?
>>    =20
>
> Yes. I'll try to post a patch soon.
>
>  =20

Sounds good.  Thanks Michael.

-Greg


--------------enigB891F47413A56DCCF1C71CC6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkodprwACgkQP5K2CMvXmqEs1wCgicf9fmODckolIBeDr6tRm0qN
kgcAn09OniHQSPMQmf1JULr3Xz9GroY5
=ZBdE
-----END PGP SIGNATURE-----

--------------enigB891F47413A56DCCF1C71CC6--
