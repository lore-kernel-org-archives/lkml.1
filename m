Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbZKLPok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbZKLPok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZKLPoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:44:39 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:44282 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbZKLPoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:44:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=WmsTc2JgFRFebefPUmerNK85DkwYFZcSjMFQ1/sH7BnErMpIp1hknJSg/FWdxgHthb
         qroVh0RwvX2jl3u7blLFgXc46Jsi05M5zOznJzwHc2qc6NqTbKA5XsLuivDYNdva0H4w
         NsMwFaquwrYg6syjOvTFzSMKnZ5F3CUsc+3ss=
Message-ID: <4AFC2D65.9040903@gmail.com>
Date: Thu, 12 Nov 2009 10:44:37 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Patrick Mullaney <pmullaney@novell.com>
CC: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kaber@trash.net, arnd@arndb.de, bridge@lists.linux-foundation.org,
       evb@yahoogroups.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] vbus: venet macvlan support
References: <20091110222632.24100.14884.stgit@mimic.site>
In-Reply-To: <20091110222632.24100.14884.stgit@mimic.site>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig75BEB90EED3DC6DAD9C707F9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig75BEB90EED3DC6DAD9C707F9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Patrick Mullaney wrote:
> (Applies to alacrityvm.git/master:34534534)
>=20
> This patchset implements a vbus venet device with a
> macvlan backend.

Thanks Pat, applied.

If possible, please submit a patch for the userspace side "-net
venet-macvlan[,macaddr][,lower-devname]" feature ASAP and I will merge
that as well.

-Greg


--------------enig75BEB90EED3DC6DAD9C707F9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkr8LWUACgkQP5K2CMvXmqGRaQCgiC071fN0Uw8BceZbqTkXPYTk
KX4Anjl1Gbm/ME8ATSrlvBEmr0FckhFM
=DijE
-----END PGP SIGNATURE-----

--------------enig75BEB90EED3DC6DAD9C707F9--
