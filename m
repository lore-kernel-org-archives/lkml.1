Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZHAGlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZHAGlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 02:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZHAGlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 02:41:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51636 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbZHAGlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 02:41:10 -0400
Date: Sat, 1 Aug 2009 16:41:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty tree change for linux-next
Message-Id: <20090801164104.5e9b2f17.sfr@canb.auug.org.au>
In-Reply-To: <20090801043905.GA12779@kroah.com>
References: <20090801043905.GA12779@kroah.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__1_Aug_2009_16_41_04_+1000_8yDF/oFflly2V5D."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__1_Aug_2009_16_41_04_+1000_8yDF/oFflly2V5D.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Fri, 31 Jul 2009 21:39:05 -0700 Greg KH <greg@kroah.com> wrote:
>
> I've now merged Alan's tty tree into my patch trees, and I'd like to ask
> for linux-next to pick them up.
>=20
> They are contained within the same directory as my other trees (staging,
> usb, driver-core), and conviently named "tty.current" and "tty", and can
> be found at:
> 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> As you can see by the nameing in the above directory, the usb and
> staging trees changed names by virtue of putting the tty tree ahead of
> them.  Your scripts might need adjusting for this.

OK, I have added/updated these.

> If there are any problems with the trees, please let me know.

Will do.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__1_Aug_2009_16_41_04_+1000_8yDF/oFflly2V5D.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpz44AACgkQjjKRsyhoI8xZhwCdFL6bcBsAC/M8MpIzPuJl6MKf
x0AAnRHal7uiAjVYLz190XForLfbCtCh
=Y4MT
-----END PGP SIGNATURE-----

--Signature=_Sat__1_Aug_2009_16_41_04_+1000_8yDF/oFflly2V5D.--
