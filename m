Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZK3MFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZK3MFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZK3MFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:05:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:45242 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZK3MFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:05:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=IRKVMhokSC2nZ+lC8Lo27Xu+TD1hJCHmW67/VEIUVkZu8yZQU1MWw6Bn4W0xN7feZ2
         7pZYukxwhaoOelF7BplKRy81dCO2baTPBq08RNs9ynSF9IlNIpZkN5dDQN06u1/xc3k4
         3ozN9vGQWw010HyEUYhMqkCykJyleD99i3NEI=
Date: Mon, 30 Nov 2009 13:05:09 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Nix <nix@esperi.org.uk>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.5 x86-64 KVM: 'emulation failed (pagetable) rip
 7fb49335da7b 66 0f 7f 07'
Message-ID: <20091130130509.52762237@varda>
In-Reply-To: <87y6lorjq6.fsf@spindle.srvr.nix>
References: <87skbzvdgd.fsf@spindle.srvr.nix>
	<4B125051.6010506@redhat.com>
	<87k4x9saqn.fsf@spindle.srvr.nix>
	<4B1283F5.5060204@redhat.com>
	<87y6lorjq6.fsf@spindle.srvr.nix>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/9bCZVuV=ARpich0=y+xdZ/V"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9bCZVuV=ARpich0=y+xdZ/V
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

El Sun, 29 Nov 2009 23:31:45 +0000
Nix <nix@esperi.org.uk> escribi=C3=B3:

> On 29 Nov 2009, Avi Kivity stated:

[...]

> Anyone know?

 When I install the infamous nvidia driver I use. =C2=AB sudo stop gdm =C2=
=BB=20
there are a start and restart aliases too see =C2=AB man initctl =C2=BB.
Sometimes is not enough though and I have to stop gdm and then pkill
the X server



--Sig_/9bCZVuV=ARpich0=y+xdZ/V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJLE7T1AAoJEDO4iEReSTB2su0QALgyBP7qJ317IQkDJOerhlKc
UKARjuNe/5fDywa5O4yeoa7WwGp4bdhULalKzUullcP+1t1csfg5NsGIMSXtRkxT
KdJ2hUXyr1EfDkQLEKHThGHcNGgOrpl03z7G4PE3CGwM6aI9WIoqunEfIiFmogO2
9OlRjwkk59CJ1UxRJ+oi1CeYSJ2uhxOHOheOS5Xs9YEZjVElYZqni77vFwGVEEJs
wO7VKxlxG7vKNxFsCqi0yYmrKIZRlEuRbGgGMSvwa/RI39nVDZuIPHQtCWR+CTRX
EF5Wo7dqi0NPUyCGRLDZ6wFrw6xXdkCfWfeoPf+iiaGV+O0qfVOFXogK6C2ThTOq
QgA9vDSJLtvP303RcmN62CKVvAh21bpeLJYr7pAad+f4MNTdkUJJMXWar8pIrUnX
eQxahAjLjflUjzt0FvzfWUERQ68aZfcb6NSuTnvgmCDTgEYWr2JB9j+G34gJvGPh
teULvWtxw5Q7+FhpiGviyv6PrYvd8WWsFMSQbxQbfm/M8HaUboFnGRkpw2KBBL7f
9sQupC1WQ9A3KNvs/OcppNSMOy0LDTFHfParYWIqg9AJPEX130HgO/odyMpKG3df
vnEErefSMGqJlK30OKJu0ncshC/tjka2l18VsUWwqllWASndTLe+YbrGiJdEf2Ds
6j/hXoFnmjk8eW7r2wkf
=1F4H
-----END PGP SIGNATURE-----

--Sig_/9bCZVuV=ARpich0=y+xdZ/V--
