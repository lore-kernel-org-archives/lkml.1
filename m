Return-Path: <linux-kernel-owner+w=401wt.eu-S1762408AbZE0LyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408AbZE0LyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762337AbZE0Lxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:53:52 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45119 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762419AbZE0Lxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:53:51 -0400
Message-ID: <4A1D29C2.7050107@novell.com>
Date: Wed, 27 May 2009 07:53:38 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com
Subject: Re: [KVM PATCH v4 1/3] eventfd: export eventfd interfaces for module
 use
References: <20090526191010.20860.75372.stgit@dev.haskins.net> <20090526191528.20860.67700.stgit@dev.haskins.net> <4A1D006F.2030501@redhat.com>
In-Reply-To: <4A1D006F.2030501@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig599DF69033E8BAEA711CD7BD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig599DF69033E8BAEA711CD7BD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

[Fixing Davide's email address]

Avi Kivity wrote:
> Gregory Haskins wrote:
>> We want to use eventfd from KVM which can be compiled as a module, so
>> export the interfaces.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com
>
> Since Davide has already acked this patch, please include this in the
> signoff section so we don't lose the paperwork.
>

Will do.

-Greg



--------------enig599DF69033E8BAEA711CD7BD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkodKcIACgkQlOSOBdgZUxmV0gCeI7nBW/RCY2T4q975r+klqFh6
oSsAn0ADrsDaoWJ7YzkefDjrlGNiy9Wk
=/IpV
-----END PGP SIGNATURE-----

--------------enig599DF69033E8BAEA711CD7BD--
