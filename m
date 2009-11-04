Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbZKDTPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbZKDTPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbZKDTPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:15:42 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:33618 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941AbZKDTPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:15:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=UlXl8Dgq+AaetKY5oy5MqHLfg8S1SujOpRfYcqr6U/msnjCwmS1hj0kMK+zz6w3hHY
         7kQ2mLrArGYMU5fJISnFHFNLy2g53McfFBA28qZpBSu8GyxwEfazY/5LSi0n0/ZstUbG
         I63WynZpl/RrSCOBcYt+DjTnwwEu3gNNySdgY=
Message-ID: <4AF1D2DE.10705@gmail.com>
Date: Wed, 04 Nov 2009 14:15:42 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       Daniel Walker <dwalker@fifo99.com>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv8 0/3] vhost: a kernel-level virtio server
References: <20091104155234.GA32673@redhat.com> <4AF1A587.8000509@gmail.com> <20091104162339.GA311@redhat.com>
In-Reply-To: <20091104162339.GA311@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE41C0DE2FBFBF3E83786E82A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE41C0DE2FBFBF3E83786E82A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, Nov 04, 2009 at 11:02:15AM -0500, Gregory Haskins wrote:
>> Michael S. Tsirkin wrote:
>>> Ok, I think I've addressed all comments so far here.
>>> Rusty, I'd like this to go into linux-next, through your tree, and
>>> hopefully 2.6.33.  What do you think?
>> I think the benchmark data is a prerequisite for merge consideration, =
IMO.
>=20
> Shirley Ma was kind enough to send me some measurement results showing
> how kernel level acceleration helps speed up you can find them here:
> http://www.linux-kvm.org/page/VhostNet

Thanks for the pointers.  I will roll your latest v8 code into our test
matrix.  What kernel/qemu trees do they apply to?

-Greg


--------------enigE41C0DE2FBFBF3E83786E82A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrx0t4ACgkQP5K2CMvXmqFRbgCeLpbxRPIlSPlPG7HtOurzxEQp
lWUAnjOvhcZm8LOVA2vlgoLaN/wgPdzQ
=JO1s
-----END PGP SIGNATURE-----

--------------enigE41C0DE2FBFBF3E83786E82A--
