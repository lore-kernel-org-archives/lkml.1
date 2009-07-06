Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZGFS2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZGFS2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZGFS2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:28:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:40570 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZGFS2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:28:31 -0400
Message-ID: <4A524243.9020100@novell.com>
Date: Mon, 06 Jul 2009 14:28:19 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 5/5] KVM: create irqfd-cleanup-wq on demand
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <20090702153821.20186.9344.stgit@dev.haskins.net> <20090706155850.GA12399@redhat.com> <4A522050.7030200@novell.com> <20090706161444.GC12399@redhat.com> <4A52272A.2060101@novell.com> <20090706165045.GF12399@redhat.com>
In-Reply-To: <20090706165045.GF12399@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE66E6543EBB1BE4AE14A71D0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE66E6543EBB1BE4AE14A71D0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Jul 06, 2009 at 12:32:42PM -0400, Gregory Haskins wrote:
>  =20
>> For the record, I would have rather just used my originally proposed
>> slow-work thread instead of all this ;)
>>    =20
>
> Or just keep the idle thread around, it's not a big deal.
>
>  =20

If everyone is fine with that, lets do that then.  It's certainly the
simplest solution to just drop this patch.

Avi?

-Greg


--------------enigE66E6543EBB1BE4AE14A71D0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpSQkcACgkQlOSOBdgZUxmOdQCeIdsRw9HTBUjpM0yG/PKi+37p
8rIAniAY2hV87sWe0pq2vR9qcGFGd9sP
=w6PC
-----END PGP SIGNATURE-----

--------------enigE66E6543EBB1BE4AE14A71D0--
