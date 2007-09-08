Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbXIHFSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbXIHFSS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 01:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXIHFSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 01:18:09 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:58060 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbXIHFSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 01:18:07 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Why do so many machines need "noapic"?
Date: Sat, 8 Sep 2007 07:17:58 +0200
User-Agent: KMail/1.9.7
Cc: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de> <46E1A7B5.6000104@redhat.com>
In-Reply-To: <46E1A7B5.6000104@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2050082.fF07aJOhfy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709080717.58271.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2050082.fF07aJOhfy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Friday 07 September 2007 Chuck Ebbert hast written:
> On 09/06/2007 07:31 AM, Andi Kleen wrote:
> > Chuck Ebbert <cebbert@redhat.com> writes:
> >> Some systems lock up without the noapic option.
> >
> > Please find patterns: cpu type, chipsets, mainboard vendors etc.
>
> This is the first one I've actually had in front of me:
>
>   HP TX1000 notebook
>   Nvidia C51/MCP51 mobile chipset

Do you have a hpet? If not, have you tried using acpi_use_timer_override wi=
th=20
apic?

bye,
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart2050082.fF07aJOhfy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iD8DBQBG4jCGxU2n/+9+t5gRAl53AKC/VOvagfQcCTof9vLp5AgHJ9e/6QCg2+us
8hp+JdFvfdNmKm77XHcMhq8=
=vazy
-----END PGP SIGNATURE-----

--nextPart2050082.fF07aJOhfy--
