Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbZEDSGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbZEDSGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbZEDSGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:06:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:38311 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbZEDSGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=pWWXg7anWIsbMbrPPvyZ8+O3gbjIi2mc/wfVkQME6GV1h8ytqcD/SF/HH1iFsOJR3a
         5STk2bHBAsu3g0ZNNSqydX83kerJoTQTzjQHsQPkwDrzqdGPX1sOpsDe4x9HrLKwXljT
         ivBtWrxekzHua6md04/0nvMeN3EGgD3aiYljA=
Message-ID: <49FF2EAB.4080307@gmail.com>
Date: Mon, 04 May 2009 14:06:35 -0400
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
 boundary="------------enigF492DEB5922FB9A39145A087"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF492DEB5922FB9A39145A087
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> (Applies to kvm.git:7da2e3ba, plus you will also need Davide Libenzi's
> eventfd_file_create() patch, which you can find here:
>  =20

[ snip ]

Sorry about the double post of v4.  The first time through I
fat-fingered Al's and LKML's addresses so they were munged together.  I
tried to kill the mail before it went out, but it looks like I missed
it.  If replying, please be sure to use the second version of v4 (which
has a legit address for Al and LKML).

-Greg



--------------enigF492DEB5922FB9A39145A087
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn/LqsACgkQP5K2CMvXmqEY7ACdFyI1lo3BGOfQlSRWuGD1Re/A
bRAAmwW88HfdKVtNmvV6wjYixlJsVzqj
=XJr4
-----END PGP SIGNATURE-----

--------------enigF492DEB5922FB9A39145A087--
