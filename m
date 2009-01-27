Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbZA0Ask@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbZA0Ask (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZA0Asc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:48:32 -0500
Received: from mail-fx0-f26.google.com ([209.85.220.26]:57876 "EHLO
	mail-fx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZA0Asb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:48:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=CDqO4P9sCo2vvXyYDlkaIdIdw39rLHgO08pDqdW2EMAru1IgP0Yqz74NDvpqQqMpgO
         fwcYTJmKUHTw2puQwDHkcy88G+yJArVHnPgMhdTU/DykKJDGKsttZ6kIsg74vJtINxVc
         3pXyRuxJprmrmEDoU3nrWFNmXvfIhDJ6MRla4=
Date: Tue, 27 Jan 2009 01:48:22 +0100
From: Max Weninger <max.weninger@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: support of touchscreen reported as eGalax but is not working
Message-ID: <20090127014822.780ecb90@zork.foo.com>
In-Reply-To: <20090127013806.5e31199f@zork.foo.com>
References: <20090125234902.7605fd16@zork.foo.com>
	<497D9469.3030908@wincor-nixdorf.com>
	<20090126124941.4f67aaf5@shire2>
	<497DA8E3.5070006@wincor-nixdorf.com>
	<20090127013806.5e31199f@zork.foo.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/slZWAxVHc_5EG9MXiJL5KvW";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/slZWAxVHc_5EG9MXiJL5KvW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi



On Tue, 27 Jan 2009 01:38:06 +0100
Max Weninger <max.weninger@gmail.com> wrote:

> Hi
>=20
> On Mon, 26 Jan 2009 13:13:23 +0100
> Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:
>=20
> > Max Weninger wrote:
> > > Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:
> > >> You can obviously download the drivers from
> > >> <http://home.eeti.com.tw/web20/TouchKitDriver/linuxDriver.htm>.
> > >>
> > >> It would be great if eGalax could be convinced to get these
> > >> drivers included in main-line ;)
> > >=20
> > > Thanks for your quick reply
> > > BUT: I have tried those driver also
> > >=20
> > > I tried this "brandnew" one (but also older ones)
> > > http://home.eeti.com.tw/web20/drivers/touch_driver/Linux/2.06.2416/To=
uchKit-2.06.2410-32b-k26.tar.gz
> > > after making it compile for 2.6.28.2 :)
> > > since there is source code delivered
> >=20
> > For what it's worth; the version we use from eGalax is 1.0.3.1701. I
> > don't have the hardware here atm, so I can't test an other driver
> > now.
>=20
> I tried kernel 2.6.23.17 and there the touchscreen is recognized
> using the builtin usbtouchscreen driver

It also works with 2.6.26.8

Regards

Max

--Sig_/slZWAxVHc_5EG9MXiJL5KvW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkl+WdoACgkQWFKBZOdSyBWtUwCgi0XwhENQE9Cp6QMpjxM3F1G8
3R8AoMFT5Wcl2ICjKpn78Bz+gx4yS2m/
=VvJ4
-----END PGP SIGNATURE-----

--Sig_/slZWAxVHc_5EG9MXiJL5KvW--
