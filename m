Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZFVNTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZFVNTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZFVNTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:19:11 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:63442 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbZFVNTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=jEZ4AQ2MQ6vFGutK9iqgcxaJL928BudlgiTOmSQ+Aj86/ZsvHk1v4Cy8sfaQTE4AHu
         OY5Yewfj1s2yqJL2jAnxTkqK7S1m36GkM7DzVvE2QqCFDUsnYxmmUkcYQNhqHOcapz4o
         UT8yteajuerCubNO8Va34NxCTdaTgxhP17H/g=
Message-ID: <4A3F834F.6040205@gmail.com>
Date: Mon, 22 Jun 2009 09:12:47 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622104435.GA11594@redhat.com> <4A3F757C.6030508@novell.com> <20090622123022.GC12867@redhat.com> <4A3F7F7C.8090700@gmail.com> <20090622130827.GD12867@redhat.com>
In-Reply-To: <20090622130827.GD12867@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig19C8B59524D63FC80FF72CAB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig19C8B59524D63FC80FF72CAB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Jun 22, 2009 at 08:56:28AM -0400, Gregory Haskins wrote:
>  =20
>>
>> Heh...well, the first one ("aggregates   one") is just a plain typo.=20
>> The others are just me showing my age, perhaps:
>>
>> http://desktoppub.about.com/cs/typespacing/a/onetwospaces.htm
>>
>> Whether right or wrong, I think I use two-spaces-after-a-period
>> everywhere.
>>    =20
>
> Ah, I see now. Naturally it is really up to you.
>
>  =20
>>  I can fix these if they bother you, but I suspect just
>> about every comment I've written has them too. ;)
>>
>> -Greg
>>    =20
>
> It doesn't bother me as such. But you seem to care about such things :)=
=2E
>  =20

Its not that I care per se.  Its that it will be a tough habit to break
as I've done it for years now ;)  (See, I even did it in this paragraph ;=
)

-Greg


--------------enig19C8B59524D63FC80FF72CAB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/g08ACgkQP5K2CMvXmqHFiQCfR52mcfuCGL4HxIN4tVtLqYP4
ADQAni041yVS1AjdrsG71dhPV1VUQ7E4
=kfmS
-----END PGP SIGNATURE-----

--------------enig19C8B59524D63FC80FF72CAB--
