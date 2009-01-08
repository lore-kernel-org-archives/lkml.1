Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbZAHRzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbZAHRzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZAHRze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:55:34 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:37091 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbZAHRzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:55:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=NkdVZnNFlvYTgu1EAboSvfJION2Ab8dcEyIzZRv5QqUV2xzW/F+rmr/dySfpX3ywve
         Du1SbslphrsOiZ+YrpuQNPuuIl5ACw97W5AbZugwCleGEW03agUbPj+kFIAOHj6gcfKr
         oPtSQScZJpczYtRo0CHNuOg5JBaxJyw41Dsj8=
Date: Thu, 8 Jan 2009 18:53:43 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, corbet@lwn.net
Subject: Re: Who wrote 2.6.28
Message-Id: <20090108185343.27602b9f.kristoffer.ericson@gmail.com>
In-Reply-To: <496224D7.2030109@cn.fujitsu.com>
References: <496224D7.2030109@cn.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__8_Jan_2009_18_53_43_+0100__azmMemwDPgh3pv="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Jan_2009_18_53_43_+0100__azmMemwDPgh3pv=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Jan 2009 23:18:47 +0800
Wang Chen <wangchen@cn.fujitsu.com> wrote:

> As Jonathon and Greg did, I also made a statistic about who wrote the Lin=
ux kernel.
> The following data is for 2.6.28 development. (http://www.remword.com/kps=
_result/)
>=20
> 1. The attachment graph "commit.png" shows the change of commit amount of=
 patches and changed lines.
>    It seems that 2.6.28 has less commits than 2.6.27 of both patch set an=
d changed lines.
>=20
> 2. The attachment graph "who.png" shows the involved developers and emplo=
yers in each version of kernel.
>    It seems that 2.6.28 has more developers and companies involved than p=
revious two versions, but
>    less than that of 2.6.25. From a long vision, more and more developers=
 and companies join to the
>    development of Linux kernel, but the increase speed is not so fast.

How about adjusting for large/small letters? eg. Kristoffer Ericson =3D=3D =
kristoffer ericson. Or Ill just learn to use the same always :)



>=20
> 3. About TOP30 employers who commit most to kernel, (http://remword.com/k=
ps_result/2_6_28_emtop)
>    Hobbyists is still the most group who contribute most to kernel develo=
pment.
>=20
> 4. About longtail, (http://remword.com/kps_result/2_6_28_lt)
>    There are 624 people who committed less than 2 patch sets, but their c=
ontribution is about 8%
>    of total.
>=20
> 5. About Reviewed-by and Tested-by.
>    More and more review and test efforts are regarded by people, Tested-b=
y sign number(173)
>    is highest in kernel development history.
>=20
> 6. Anyone who wants to check some person or company's contribution curve,=
 please use
>    http://remword.com/kps_result/evolvement.php
>=20
> BTW:
> To collect information about developers' employ relationship, I search on=
 the Internet
> (not by asking themselves) and use gitdm-config which is created by Jonat=
hon and Greg.
> Thanks Jonathon and Greg :)
>=20
> --
> WCN
>=20
>=20
>=20


--=20
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Signature=_Thu__8_Jan_2009_18_53_43_+0100__azmMemwDPgh3pv=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklmPacACgkQPQls10ERAGddIwCfU7rFRf/93fXDzBKhl23PwWaE
8gYAn2D3tgMtFhh7Th4/pqstQGIyqO8D
=A1Z0
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Jan_2009_18_53_43_+0100__azmMemwDPgh3pv=--
