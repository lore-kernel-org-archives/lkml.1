Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbZKDTNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbZKDTNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbZKDTNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:13:10 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:63087 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784AbZKDTNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:13:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=ZHKXpIo4pRPici9cZSE+9j4d5ERnsj/M4nYFJe5xPNcmnRE1q1BTprr6LcHk+dyORr
         CZGoB63vYD1Uko9MJ/TTBeOXUv3nDeAIOSa91NxSz3FpyXjCR01oAhc7afakj9n+IJS8
         RSVvH/lRgZtFcxekxpmqVmruilGW2AkcKFPTY=
Message-ID: <4AF1D233.7050409@gmail.com>
Date: Wed, 04 Nov 2009 14:12:51 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com
Subject: Re: [PATCHv7 3/3] vhost_net: a kernel-level virtio server
References: <cover.1257267892.git.mst@redhat.com> <20091103172422.GD5591@redhat.com> <4AF0708B.4020406@gmail.com> <4AF07199.2020601@gmail.com> <4AF072EE.9020202@gmail.com> <20091103235744.GF6726@linux.vnet.ibm.com> <20091104115729.GD8398@redhat.com> <20091104172542.GC6736@linux.vnet.ibm.com> <20091104190609.GB772@redhat.com>
In-Reply-To: <20091104190609.GB772@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCCA63008B2D675AA17A46E78"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCCA63008B2D675AA17A46E78
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, Nov 04, 2009 at 09:25:42AM -0800, Paul E. McKenney wrote:
>> (Sorry, but, as always, I could not resist!)
>>
>> 							Thanx, Paul
>=20
> Thanks Paul!
> Jonathan: are you reading this?
> Another one for your quotes of the week collection :)
>=20

I second that.


--------------enigCCA63008B2D675AA17A46E78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrx0jMACgkQP5K2CMvXmqE8mQCfdYADcYmCghf4KZwD0wmBm3nY
8dAAn0L2oESRSjXqAFFqur1MOK0OCYC9
=7C80
-----END PGP SIGNATURE-----

--------------enigCCA63008B2D675AA17A46E78--
