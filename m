Return-Path: <linux-kernel-owner+w=401wt.eu-S1751565Ab0ARFlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab0ARFlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 00:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458Ab0ARFly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 00:41:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52886 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab0ARFlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 00:41:53 -0500
Date: Mon, 18 Jan 2010 16:41:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: vfs tree build warning
Message-Id: <20100118164148.3452f553.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.1001172032590.16533@cobra.newdream.net>
References: <20100118131139.1ef42c6f.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.1001172032590.16533@cobra.newdream.net>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jan_2010_16_41_48_+1100_jb5zjOJAZTuqSedF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jan_2010_16_41_48_+1100_jb5zjOJAZTuqSedF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

On Sun, 17 Jan 2010 20:34:29 -0800 (PST) Sage Weil <sage@newdream.net> wrot=
e:
>
> I can put this in the for-next branch of the ceph tree.

Not unless you first merge the vfs tree into the ceph tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jan_2010_16_41_48_+1100_jb5zjOJAZTuqSedF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktT9JwACgkQjjKRsyhoI8y2KgCfT6J9M7EUs+6EWpqtDj0CK4XB
H5QAnjuYHhtbhoiYa9O0+a+wxjiEwF9i
=kmfK
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jan_2010_16_41_48_+1100_jb5zjOJAZTuqSedF--
