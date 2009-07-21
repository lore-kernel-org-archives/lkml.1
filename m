Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZGUUna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZGUUna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbZGUUn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:43:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:29090 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZGUUn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=Q2IEiAD+ijN4PO9RHeLS7/86ekDUq80w94Filpw7HrTAwhsUExmtdtoeSgMXmIp/dJ
         C17mPGdseggdckoOyA/CxzCq/ZvzmTGqmXpj6sS/CAbCiw5f0wNbRHBOBbuerZYFRxTD
         0CMvkyEFD0Gv54ybbPRjGPwAThD87gpK4lwqo=
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com, tglx@linutronix.de,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <20090721160436.GD4352@dtor-d630.eng.vmware.com>
References: <20090714100634.GA4054@elf.ucw.cz>
	 <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com>
	 <20090715133627.GA2538@elf.ucw.cz>
	 <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
	 <20090721105924.GK4133@elf.ucw.cz> <20090721113642.GC13286@sirena.org.uk>
	 <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com>
	 <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com>
	 <20090721124933.GA5668@rakim.wolfsonmicro.main>
	 <20090721160436.GD4352@dtor-d630.eng.vmware.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OhjLO42kfIzVIPhva3bN"
Date: Tue, 21 Jul 2009 17:43:15 -0300
Message-Id: <1248208995.4333.46.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OhjLO42kfIzVIPhva3bN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em Ter, 2009-07-21 =C3=A0s 09:04 -0700, Dmitry Torokhov escreveu:
> On Tue, Jul 21, 2009 at 01:49:33PM +0100, Mark Brown wrote:

> >  - Multi-function devices like the twl4030 which have an interrupt
> >    controller on them and would like to expose that interrupt controlle=
r
> >    via the generic IRQ subsystem.  This was a large part of the
> >    discussion in the thread above is a much trickier problem.
> >=20
> > I've added the folks from Samsung posting the MELFAS MCS-5000 driver to
> > the thread since they're running into the same issue.
> >=20
> Let's also add Thomas and David since I believe they worked on the
> feature.

Please, keep me on CC too, pcap has an interrupt controller, is
connected to SPI bus and exposes its interrupts via generic IRQ
subsystem.

--=20
Daniel Ribeiro

--=-OhjLO42kfIzVIPhva3bN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpmKGMACgkQw3OYl0G0liSBoACfUmMi1epB1ROtkx6SfNyd1DEK
nFsAoIq3RNP2Tb9IboODK8eG2srrXWGw
=xZZe
-----END PGP SIGNATURE-----

--=-OhjLO42kfIzVIPhva3bN--

