Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZGHLkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZGHLkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZGHLkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:40:43 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48600 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbZGHLkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:40:42 -0400
Message-ID: <4A5485AB.2000807@novell.com>
Date: Wed, 08 Jul 2009 07:40:27 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [KVM PATCH v9 1/2] KVM: make io_bus interface more robust
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203315.14222.25490.stgit@dev.haskins.net> <20090707112035.GB3647@redhat.com> <4A538533.3030703@novell.com> <20090708074742.GA10803@redhat.com>
In-Reply-To: <20090708074742.GA10803@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4BCC5F16E07C611749CEB324"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4BCC5F16E07C611749CEB324
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jul 07, 2009 at 01:26:11PM -0400, Gregory Haskins wrote:
>  =20
>
>> I suppose its personal preference either way, so I guess unless Avi
>> objects lets just each have our own style in that regard.
>>    =20
>
> I think Avi already said we don't need to standardize everything.
> I hope at least some of the comments were helpful.
>
>  =20
Yes, it was very helpful and I really *do* appreciate the time you take
to review the code.  I think you will see that aside from the things we
agree are whitespace style, I addressed your feedback in v10.  The one
notable omission (and this was not intentional) was that I forgot to
document the return value like you requested.  If a v11 is needed after
review comments, I will update it then.  Otherwise, Ill just submit a
trivial doc patch after v10 is accepted.

Thanks again, Michael,
-Greg


--------------enig4BCC5F16E07C611749CEB324
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpUha8ACgkQlOSOBdgZUxk0zwCfc4ZGTwozdmSBN7FT4rikHulS
+ZIAoI76Xqic/s7+nfM6QhSlOiT5gz1A
=vepI
-----END PGP SIGNATURE-----

--------------enig4BCC5F16E07C611749CEB324--
