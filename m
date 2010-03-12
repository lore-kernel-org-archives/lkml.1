Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab0CLJyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:54:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36853 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab0CLJyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:54:38 -0500
Date: Fri, 12 Mar 2010 20:54:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (backlight related)
Message-Id: <20100312205428.42a3e405.sfr@canb.auug.org.au>
In-Reply-To: <1268328970.1625.2.camel@rex>
References: <20100310180343.c6305829.sfr@canb.auug.org.au>
	<1268328970.1625.2.camel@rex>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Mar_2010_20_54_28_+1100_fw3ye4YbruDCmBAO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Mar_2010_20_54_28_+1100_fw3ye4YbruDCmBAO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Thu, 11 Mar 2010 09:36:10 -0800 Richard Purdie <rpurdie@rpsys.net> wrote:
>
> Sorry about that, I knew there were going to be issues with that patch
> and had meant to commit and test but not push until I fixed that issue.
> I've fixed up the tree now.

Yep, looks good today, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Mar_2010_20_54_28_+1100_fw3ye4YbruDCmBAO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuaD1QACgkQjjKRsyhoI8zdeACgq6690uXEzFNt0rPC5848bMQa
3gsAoLH0DispdIAW51L0C9CuXR1+1y2z
=sx+G
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Mar_2010_20_54_28_+1100_fw3ye4YbruDCmBAO--
