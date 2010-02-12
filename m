Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab0BLQz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:55:57 -0500
Received: from nn7.de ([85.214.94.156]:44827 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063Ab0BLQzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:55:55 -0500
Subject: Re: Brightness control for MacBook Pro - Nvidia 9400
From: Soeren Sonnenburg <sonne@debian.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Julien BLACHE <jb@jblache.org>, nicolas@boichat.ch,
       felipe_alfaro@linuxmail.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100212164412.GA21279@srcf.ucam.org>
References: <1265920725.7103.7.camel@no>
	 <878wayk8hn.fsf@sonic.technologeek.org>
	 <20100212141457.GA18714@srcf.ucam.org>
	 <87zl3eto99.fsf@sonic.technologeek.org>
	 <20100212162810.GA20998@srcf.ucam.org> <1265992937.3485.34.camel@no>
	 <20100212164412.GA21279@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-G8rvj5Hhg0h2wh5e3C/O"
Date: Fri, 12 Feb 2010 17:55:56 +0100
Message-ID: <1265993756.3485.35.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-G8rvj5Hhg0h2wh5e3C/O
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-12 at 16:44 +0000, Matthew Garrett wrote:
> On Fri, Feb 12, 2010 at 05:42:17PM +0100, Soeren Sonnenburg wrote:
> > On Fri, 2010-02-12 at 16:28 +0000, Matthew Garrett wrote:
> > > On Fri, Feb 12, 2010 at 05:25:22PM +0100, Julien BLACHE wrote:
> > >=20
> > > > Is it exposed to userspace in any way? Or, better yet, could we hav=
e an
> > > > MBP backlight driver which would hide all of this from userspace?
> > >=20
> > > Sure, in nouveau.
> >=20
> > OK, great convinced. Any suggestions on where to add printk's to figure
> > out the cause of the hang? The only thing I noticed was the fans turnin=
g
> > on so the machine is either stuck in a busy loop or ???
>=20
> Best bet is probably to file a bug on bugs.freedesktop.org - I'm afraid=20
> I'm not too hot on the GPU bringup side of the driver.

OK, it is here
http://bugs.freedesktop.org/show_bug.cgi?id=3D26546

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-G8rvj5Hhg0h2wh5e3C/O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLdYgcAAoJEH82z1Wqh6p3hHoQAMyFvl8YHXQgqe8tvqHCtSAy
bT9Hd3c/CX3lhXboErdU0p4nENWEGkDOQOgiP1V3p4Xaigw4xALHsxYprcigB+FB
DHc9C6PHgOqDIcxbQDaxFbvoQ4SLUL2nb9Y+o59aL4nD6oDQFIAgNCRA29yHhivz
jzkvSdixMbafabS1MaL2s17av6107kS29gBKcBK4qvoXqSUR65Ad1EtNCDvabzFQ
9kItwmPr5Ly4TGNseGFFUpeTCAxcxPvHXKB4xp8stTRiRHkWdSfoUjHTJ5QGCKGz
FmrJiXM+igSHxHhBlIhGKUkPc1IvQ0M3KFl0cb18H9Fc4Ztci0HlcTGPBUIZXMge
2MHoQiMAq6nBjQ9VAcUSUqzhAwB9goX5X31t4PeHLGQI13VWtmJeBjsd930xmLhS
9+yQXYrDdJZjYRnxgsa/Ixb9fv4CKiPoIcF8rToKofizvbvzql2SfwIZKYCQQFLd
XqMMG5JXUDTVaQtoWWLb/LTU5YPgRFJ/I2+XnYBWNWW7bGxVSRlQntEBR3Mm1Zpp
gYJU8MnqBAHWtZx64w+NgVxDHwk406SAOIDOhSFnWBd/N/R7hdE/j2JDrMpEnLGZ
xKQeQt5Ur2QV8VTLXxuAS1CHdH2p8A1Fd7iZglLFJ0rzyhs4u/ZCVoi/fBfNNdI6
5TEBSCbTMUMH5Q3zyxtP
=jBs0
-----END PGP SIGNATURE-----

--=-G8rvj5Hhg0h2wh5e3C/O--
