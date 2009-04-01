Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbZDAAMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbZDAAMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbZDAAMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:12:35 -0400
Received: from ist.d-labs.de ([213.239.218.44]:36165 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580AbZDAAMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:12:34 -0400
Date: Wed, 1 Apr 2009 02:12:18 +0200
From: Florian Mickler <florian@mickler.org>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       keithp@keithp.com
Subject: Re: [PATCH 6/6] drm/i915: Fix lock order reversal in GEM relocation
 entry copying. -- makes X hang
Message-ID: <20090401021218.4ca403cd@schatten>
In-Reply-To: <1238528216.8369.390.camel@gaiman.anholt.net>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	<1238017510-26784-2-git-send-email-eric@anholt.net>
	<1238017510-26784-3-git-send-email-eric@anholt.net>
	<1238017510-26784-4-git-send-email-eric@anholt.net>
	<1238017510-26784-5-git-send-email-eric@anholt.net>
	<1238017510-26784-6-git-send-email-eric@anholt.net>
	<1238017510-26784-7-git-send-email-eric@anholt.net>
	<20090330120011.0d506d20@schatten>
	<1238528216.8369.390.camel@gaiman.anholt.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qyuQlEhbjOMp.XdlVQFP_o/";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qyuQlEhbjOMp.XdlVQFP_o/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Mar 2009 12:36:56 -0700
Eric Anholt <eric@anholt.net> wrote:

>=20
> Ouch.  Could you file a bug report using:
>=20
> http://intellinuxgraphics.org/how_to_report_bug.html
>=20
> so I've got the information I need to try to reproduce this?
>=20

shure. done.

http://bugs.freedesktop.org/show_bug.cgi?id=3D20985

thx,

Florian

p.s. hope i didn't miss some vital piece of information?

--Sig_/qyuQlEhbjOMp.XdlVQFP_o/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAknSsWgACgkQPjqCkyL3Kv38TQCfZmtGxAeRQtWnEVkeEXOUpDFn
vyEAnA185ECrk22A7SPBCHDdbCUFbww/
=Xzsx
-----END PGP SIGNATURE-----

--Sig_/qyuQlEhbjOMp.XdlVQFP_o/--
