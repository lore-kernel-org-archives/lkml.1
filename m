Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab0BDQfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:35:00 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:51196 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab0BDQe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:34:59 -0500
From: Eric Anholt <eric@anholt.net>
To: David John <davidjon@xenontk.org>, jbarnes@virtuousgeek.org,
       yakui.zhao@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Disable SR when more than one pipe is enabled
In-Reply-To: <1264585748-16929-1-BlackWidow-davidjon@xenontk.org>
References: <4B60080E.2000508@xenontk.org>
	<1264585748-16929-1-BlackWidow-davidjon@xenontk.org>
Date: Thu, 04 Feb 2010 08:35:26 -0800
Message-ID: <878wb9rmb5.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Jan 2010 15:19:08 +0530, David John <davidjon@xenontk.org> wrote:
> Self Refresh should be disabled on dual plane configs.
> Otherwise, as the SR watermark is not calculated for
> such configs, switching to non VGA mode causes FIFO
> underrun and display flicker.
>=20
> This fixes Korg Bug # 14897.

Applied.  Thanks!

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktq904ACgkQHUdvYGzw6vfwagCgje5gr1D/YSIsrEV+Bf+SKGyJ
vPoAn2Ps3p7qAar9mYEHef5IsZywQKlJ
=ShAt
-----END PGP SIGNATURE-----
--=-=-=--
