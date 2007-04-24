Return-Path: <linux-kernel-owner+w=401wt.eu-S1422782AbXDXR06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422782AbXDXR06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422778AbXDXR05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:26:57 -0400
Received: from attic.omnifarious.org ([216.254.16.17]:48099 "EHLO
	attic.omnifarious.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422782AbXDXR05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:26:57 -0400
Subject: Re: SOME STUFF ABOUT REISER4
From: "Eric M. Hopper" <hopper@omnifarious.org>
To: lkml777@123mail.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1177395453.29737.1186216313@webmail.messagingengine.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <11769695763104-git-send-email-ebiederm@xmission.com>
	 <20070422123155.GF20763@infradead.org>
	 <20070423205020.GR31947@austin.ibm.com>
	 <1177378733.14873.52.camel@localhost.localdomain>
	 <m1ejmav80l.fsf@ebiederm.dsl.xmission.com>
	 <1177382544.14873.57.camel@localhost.localdomain>
	 <m1abwyv4oq.fsf@ebiederm.dsl.xmission.com>
	 <1177390842.14873.94.camel@localhost.localdomain>
	 <m1zm4ytjhg.fsf@ebiederm.dsl.xmission.com>
	 <1177395453.29737.1186216313@webmail.messagingengine.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-azbVGdDEc9fl9aH9cteZ"
Organization: Omnifarious Software
Date: Tue, 24 Apr 2007 10:26:55 -0700
Message-Id: <1177435615.3315.5.camel@bats.omnifarious.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-azbVGdDEc9fl9aH9cteZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-23 at 23:17 -0700, lkml777@123mail.org wrote:
> On Sun, 22 Apr 2007 19:00:46 -0700, "Eric Hopper"
> <hopper@omnifarious.org> said:
>=20
> > I know that this whole effort has been put in disarray by the
> > prosecution of Hans Reiser, but I'm curious as to its status. Is
> > Reiser4 going to be going into the Linus kernel anytime soon? Is there
> > somewhere I should be looking to find this out without wasting bandwidt=
h
> > here?
>=20
> There was a thread the other day, that talked about Reiser4.
>=20
> It took a while but I have found it (actually two)
>=20
> http://lkml.org/lkml/2007/4/5/360
> http://lkml.org/lkml/2007/4/9/4
>=20
> You may want to check them out.

I did.  That whole thread is some guy spouting off a ludicrous Bonnie++
benchmark showing that compressing long strings of 0s results in things
taking up very little space and being very fast.

Such things will produce lots of flames and no useful information
whatsoever as is evinced by the half conspiracy theory, half truth the
thread degenerated into in the second message you linked to.

*sigh*,
--=20
Eric Hopper (http://www.omnifarious.org/~hopper/)

--=-azbVGdDEc9fl9aH9cteZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP MESSAGE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGLj3XjtsvlOwvazYRAmviAJ48LYJZd3Ld97yf0PMG3vxisC3JqgCfdJ6o
ztRadtWk+6XX47WalYMCuu8=
=e61U
-----END PGP MESSAGE-----

--=-azbVGdDEc9fl9aH9cteZ--
