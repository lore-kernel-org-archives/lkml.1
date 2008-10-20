Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbYJTLKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbYJTLKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 07:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYJTLKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 07:10:08 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54662 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYJTLKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:10:07 -0400
Date: Mon, 20 Oct 2008 13:10:02 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrey Mirkin <major@openvz.org>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
Message-ID: <20081020111002.GQ15171@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1220439476-16465-1-git-send-email-major@openvz.org> <1224286383.1848.65.camel@nimitz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-18430-1224500858-0001-2"
Content-Disposition: inline
In-Reply-To: <1224286383.1848.65.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-18430-1224500858-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2008 at 04:33:03PM -0700, Dave Hansen wrote:
> On Wed, 2008-09-03 at 14:57 +0400, Andrey Mirkin wrote:
> > This patchset introduces kernel based checkpointing/restart as it is
> > implemented in OpenVZ project. This patchset has limited functionality =
and
> > are able to checkpoint/restart only single process. Recently Oren Laaden
> > sent another kernel based implementation of checkpoint/restart. The main
> > differences between this patchset and Oren's patchset are:
>=20
> Hi Andrey,
>=20
> I'm curious what you want to happen with this patch set.  Is there
> something specific in Oren's set that deficient which you need
> implemented?  Are there some technical reasons you prefer this code?

To be fair, and since (IIRC) the initial intent was to start with OpenVZ's
approach, shouldn't Oren answer the same questions with respect to Andrey's
patchset?

I'm afraid that we are forgetting to take the best from both approaches...

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-18430-1224500858-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI/GcKVKcRuvQ9Q1QRArmIAJ4r+JfcUcP486ebG579fAj+6aHnbwCfecUs
rHDCFgBvKg+2ZaLVbbX47uM=
=qII/
-----END PGP SIGNATURE-----

--=_bohort-18430-1224500858-0001-2--
