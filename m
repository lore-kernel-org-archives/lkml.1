Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZGGL0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZGGL0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZGGL0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:26:24 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58087 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbZGGL0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:26:23 -0400
Message-ID: <4A5330DB.2030505@novell.com>
Date: Tue, 07 Jul 2009 07:26:19 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 5/5] KVM: create irqfd-cleanup-wq on demand
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <20090702153821.20186.9344.stgit@dev.haskins.net> <20090706155850.GA12399@redhat.com> <4A522050.7030200@novell.com> <20090706161444.GC12399@redhat.com> <4A52272A.2060101@novell.com> <20090706165045.GF12399@redhat.com> <4A524243.9020100@novell.com> <4A52DA60.8040200@redhat.com>
In-Reply-To: <4A52DA60.8040200@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7EDE01378CB46E5946B1BF1B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7EDE01378CB46E5946B1BF1B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 07/06/2009 09:28 PM, Gregory Haskins wrote:
>> Michael S. Tsirkin wrote:
>>  =20
>>> On Mon, Jul 06, 2009 at 12:32:42PM -0400, Gregory Haskins wrote:
>>>
>>>    =20
>>>> For the record, I would have rather just used my originally proposed=

>>>> slow-work thread instead of all this ;)
>>>>
>>>>       =20
>>> Or just keep the idle thread around, it's not a big deal.
>>>
>>>
>>>     =20
>>
>> If everyone is fine with that, lets do that then.  It's certainly the
>> simplest solution to just drop this patch.
>>
>> Avi?
>>
>>   =20
>
> Sure.  If someone complains we can address it then.
>
Ok, sounds good.

Thanks guys.
-Greg


--------------enig7EDE01378CB46E5946B1BF1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpTMN8ACgkQlOSOBdgZUxmdyACgi6eFtTVVHfmg5FT0XqZX7ovQ
5XsAn3ukOvtxcNH5DHpx4LdAJCJ15dG1
=yTfh
-----END PGP SIGNATURE-----

--------------enig7EDE01378CB46E5946B1BF1B--
