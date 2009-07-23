Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbZGWRLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbZGWRLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZGWRLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:11:46 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:53333 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZGWRLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:11:45 -0400
Date: Thu, 23 Jul 2009 19:11:41 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: linux@arm.linux.org.uk, hpa@zytor.com
Cc: alain@knaff.lu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH 4/5] Add support for LZO-compressed kernels for ARM
Message-ID: <20090723171141.GG4625@pc-ras4041.res.insa>
References: <1248271279-9920-1-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-2-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-3-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-4-git-send-email-albin.tonnerre@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dgjlcl3Tl+kb3YDk"
Content-Disposition: inline
In-Reply-To: <1248271279-9920-4-git-send-email-albin.tonnerre@free-electrons.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dgjlcl3Tl+kb3YDk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2009 at 04:01:18PM +0200, Albin Tonnerre wrote :
> This is the second part of patch. This part includes:
>  - changes to ach/arch/boot/Makefile to make it easier to add new
>    compression types
>  - new piggy.lzo.S necessary for lzo compression
>  - changes in arch/arm/boot/compressed/misc.c to allow the use of lzo or
>    gzip, depending on the config
>  - Kconfig support
>=20

I failed to mention this in the first place, but for proper crediting it sh=
ould
be noted that the ARM part of the patch is based on Alain Knaff's work on t=
he
LZMA/Bzip compression patch for ARM.

Regards,
--=20
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com

--dgjlcl3Tl+kb3YDk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKaJnNAAoJEBEG8gBbtuSlwyQP/1w4nLEe+QIIwnh0gNqE3VMI
G5c7x9/eZjEOcSZY/qOW98ebbptXi5aaGR1A5tp4RIyiE2m77NodhpCDpJxM9Ox+
t1NiO/7Ksu+9/5DY3Gg5dC7sHssEHVqHALSXrp/hcpODBXBGCa8SR003MxdCAcgq
9gx70HII8AK80UCo51K+2h5ZMYDwr4xo96ucWnHR4jqUy5Ne09jH+JDbi0uQ1Dxo
2HEhWYT4/MIWnuF6BKNssNPmz5qwnFLwmzoFm/qHpWNcfi8w1aTqLhCEgXSTh8Vc
1p2/4NwvQ/16hsfmy3lc5nI1kJOXDXvWXa4I4mdxCLitIPieTPFKfv6e2RbsMe9v
zn6uh8S9q+KpKpHWAspYWs469jhbeTjlV7/aytOGTWnRvClqtymHJwxRvWoGKUeR
aeOx6x196SZVUye7Hgi7z5NvvbBOBRCBusqAkFzKgTY0kVgsfDjcbe/Rhowo3AOB
8YLLyVIDANNvfpERl2BjHLbiQgzKTT5Qun6UgJtL5RzYmMWuxOoO07OINKPzXcyr
tdmn7JQgT/FeAGas9xeJ6CMSnjdtG9En9ofjAuTsK2sRzL7hDdPIEaJow8bjrbhr
EourGvO3pynl4f5rxO/vmilZg3ClXqKuUz+9sCvUFWmVTaCZwhnjhtRkUiDnYPuV
Yaht6PTs4BPyj8+u8pal
=Wt/J
-----END PGP SIGNATURE-----

--dgjlcl3Tl+kb3YDk--
