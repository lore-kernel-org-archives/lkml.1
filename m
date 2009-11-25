Return-Path: <linux-kernel-owner+w=401wt.eu-S934681AbZKYNET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934681AbZKYNET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934670AbZKYNER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:04:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33447 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934639AbZKYNEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:04:11 -0500
Date: Thu, 26 Nov 2009 00:04:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: linux-next: percpu tree build failure
Message-Id: <20091126000411.8fa198fd.sfr@canb.auug.org.au>
In-Reply-To: <4B0D29D9.1090809@kernel.org>
References: <20091125234133.4d603f48.sfr@canb.auug.org.au>
	<4B0D29D9.1090809@kernel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Nov_2009_00_04_11_+1100_/2=ix_arjpYTG_JN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Nov_2009_00_04_11_+1100_/2=ix_arjpYTG_JN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Wed, 25 Nov 2009 21:58:01 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> The change was missing asm/io.h include and the fix commit was
> incorrectly attributed to me.  Fixed both problems.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Nov_2009_00_04_11_+1100_/2=ix_arjpYTG_JN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksNK0sACgkQjjKRsyhoI8x7BgCfdzmKflDncFS+eM3QOQiFaXFx
1JkAn1hs5YjkN1EfL7cPgX/hwHD+ic/b
=dNn8
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Nov_2009_00_04_11_+1100_/2=ix_arjpYTG_JN--
