Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbZKHXjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbZKHXjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 18:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZKHXjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 18:39:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36632 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbZKHXjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 18:39:12 -0500
Date: Mon, 9 Nov 2009 10:39:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: tip tree build warning
Message-Id: <20091109103913.3b06914c.sfr@canb.auug.org.au>
In-Reply-To: <20091108131645.GD5300@lenovo>
References: <20091028181443.50a09dbb.sfr@canb.auug.org.au>
	<20091028073145.GD6353@elte.hu>
	<20091028184126.b5f52d1b.sfr@canb.auug.org.au>
	<20091028184851.504752ef.sfr@canb.auug.org.au>
	<20091028075012.GD19402@elte.hu>
	<20091108131645.GD5300@lenovo>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Nov_2009_10_39_13_+1100_KdNoRR__2T//UX9p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Nov_2009_10_39_13_+1100_KdNoRR__2T//UX9p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cyril,

On Sun, 8 Nov 2009 16:16:45 +0300 Cyrill Gorcunov <gorcunov@openvz.org> wro=
te:
>
> (Btw, Stephen could you CC me next time if you get commit id
>  with me in authors, so I wouldn't miss problem).

Yeah, sorry about that - at the time I didn't know if this was caused
directly by your commit or was just a side effect of some some other tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Nov_2009_10_39_13_+1100_KdNoRR__2T//UX9p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr3VqEACgkQjjKRsyhoI8yPWwCgsIEVeFDksjy5xmNPR8ZjyBG3
aM4An08ZTd7U0eCvAdvwaM12zgwITPf5
=y5Hu
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Nov_2009_10_39_13_+1100_KdNoRR__2T//UX9p--
