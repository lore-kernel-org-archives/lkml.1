Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbYH0P5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbYH0P5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYH0P51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:57:27 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:58092 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbYH0P51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:57:27 -0400
Date: Wed, 27 Aug 2008 17:57:25 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
Message-ID: <20080827155725.GD14473@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu> <1219437422.20559.146.camel@nimitz> <48B0F449.2000006@cs.columbia.edu> <1219768406.8680.17.camel@nimitz> <48B49C61.1040003@cs.columbia.edu> <1219851696.8680.67.camel@nimitz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-18826-1219852514-0001-2"
Content-Disposition: inline
In-Reply-To: <1219851696.8680.67.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-18826-1219852514-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2008 at 08:41:36AM -0700, Dave Hansen wrote:
>=20
> Dang.  What's the thing we return from system calls that are
> unsupported?  Did I just dream that up?

ENOSYS?

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-18826-1219852514-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFItXllVKcRuvQ9Q1QRAsEKAJ0bn2Hjh3+uABYUFRnCWfC9V7lTEACgnHsl
Mf8Xp9ZoeWLQg18d4SHSDps=
=vHDg
-----END PGP SIGNATURE-----

--=_bohort-18826-1219852514-0001-2--
