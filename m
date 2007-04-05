Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbXDECCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbXDECCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 22:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932562AbXDECCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 22:02:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36193 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbXDECCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 22:02:42 -0400
Date: Thu, 5 Apr 2007 12:02:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] allow vmsplice to work in 32-bit mode on ppc64
Message-Id: <20070405120253.0b0ee501.sfr@canb.auug.org.au>
In-Reply-To: <20070404172519.GZ11029@redhat.com>
References: <20070404172519.GZ11029@redhat.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_Apr_2007_12_02_53_+1000_9LKyofxMlXZB_VUX"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Apr_2007_12_02_53_+1000_9LKyofxMlXZB_VUX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Wed, 4 Apr 2007 13:25:19 -0400 Don Zickus <dzickus@redhat.com> wrote:
>
> Trivial change to pass vmsplice arguments through the compat layer on
> pp64.
>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

Obviously noone uses vmsplice from 32bit processes on ppc64 :-)
--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Apr_2007_12_02_53_+1000_9LKyofxMlXZB_VUX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGFFjYFdBgD/zoJvwRAkR7AJ4+YRV8R+JXuE6lBZKPBa1rcXlI2ACdGOqK
4vFm79w+F6OPHElIdAVYuS4=
=l4Bp
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Apr_2007_12_02_53_+1000_9LKyofxMlXZB_VUX--
