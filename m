Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZEDSww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZEDSww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZEDSwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:52:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:48783 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZEDSwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=oMMJmoKGnZyEaVSYqbLLcAPxJZYniWnpkBM2nhuLvDGIUodadDabmYdwPODA7U2HoB
         CtG4vRpNtf28CLBfBcAD0lM1WkFYUbkH8jjyNnjKLAjVAdUWlKQLTLvydTGQik8VSsm6
         vvnK2QDdSEnGg1VFoQBxRTH/nTIR/uYCE44LA=
Message-ID: <49FF3974.6000203@gmail.com>
Date: Mon, 04 May 2009 14:52:36 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       avi@redhat.com, davidel@xmailserver.org
Subject: Re: [KVM PATCH v4 0/2] irqfd
References: <20090504175657.26758.12503.stgit@dev.haskins.net>
In-Reply-To: <20090504175657.26758.12503.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9AE1A23FE4C39B700D8E83EF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9AE1A23FE4C39B700D8E83EF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> (Applies to kvm.git:7da2e3ba, plus you will also need Davide Libenzi's
> eventfd_file_create() patch, which you can find here:
>  =20
[snip]

I should also add that v4 is build-tested only.  I am in the middle of
refactoring virtual-bus, which is my only current test-harness for
this.  I will report back later this week how the testing goes once I
get something running again.

-Greg



--------------enig9AE1A23FE4C39B700D8E83EF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn/OXUACgkQP5K2CMvXmqF+hQCfXzqrNs0lj/9LFCFo5YiV39cL
kQcAnjuq+dVqDcdjYUqU7euvN62zapn6
=GKMW
-----END PGP SIGNATURE-----

--------------enig9AE1A23FE4C39B700D8E83EF--
