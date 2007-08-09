Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbXHIVEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbXHIVEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbXHIVEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:04:36 -0400
Received: from server.klug.on.ca ([205.189.48.131]:4710 "EHLO
	server.klug.on.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbXHIVEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:04:35 -0400
Subject: Re: Re:
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46BB7A29.4080409@rtr.ca>
References: <1186504459.6949.40.camel@pc.ilinx>  <46BB7A29.4080409@rtr.ca>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6hDJ4LSYiLy6xlCxXo3h"
Date: Thu, 09 Aug 2007 17:04:32 -0400
Message-Id: <1186693472.6259.97.camel@pc.ilinx>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6hDJ4LSYiLy6xlCxXo3h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-09 at 16:33 -0400, Mark Lord wrote:
> Probably something to do with either LVM or the Device Mapper having
> the raw partition already "open" for some remapping purpose.
> There was a note about that around here somewhere quite recently..

Indeed, that was it.  I posted a followup "Re: [SOLVED] problems while
mounting /boot partition" reporting such.

Thanx for the heads up though!

b.

--=20
My other computer is your Microsoft Windows server.

Brian J. Murrell

--=-6hDJ4LSYiLy6xlCxXo3h
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGu4Fgl3EQlGLyuXARAqEQAJ4nxpoDt4o6jq8LGhp5gr+fCCGtPQCffrZR
f8eVNOIhhPrOmV/4QIpIUVo=
=7hgq
-----END PGP SIGNATURE-----

--=-6hDJ4LSYiLy6xlCxXo3h--

