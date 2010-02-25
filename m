Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab0BYAWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 19:22:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33060 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559Ab0BYAWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 19:22:44 -0500
Date: Thu, 25 Feb 2010 11:22:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-arch@vger.kernel.org,
       tony@bakeyournoodle.com
Subject: Re: [PATCH -v2 2/2] genericirq: change ack/mask in irq_chip to take
 irq_desc instead of irq
Message-Id: <20100225112234.5f7d345c.sfr@canb.auug.org.au>
In-Reply-To: <4B85A331.7040909@kernel.org>
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
	<m1zl3dre9e.fsf@fess.ebiederm.org>
	<4B7676BB.8030608@kernel.org>
	<m1ljexpcjp.fsf@fess.ebiederm.org>
	<4B772A54.1000000@kernel.org>
	<m16360ohi2.fsf@fess.ebiederm.org>
	<4B773CEB.9010609@kernel.org>
	<m1sk94mzg0.fsf@fess.ebiederm.org>
	<4B7CA9A1.3020806@kernel.org>
	<4B7CAADD.2060000@kernel.org>
	<m1mxz6v4pm.fsf@fess.ebiederm.org>
	<4B83781B.20307@kernel.org>
	<4B837930.2050907@kernel.org>
	<m1ljei5n9q.fsf@fess.ebiederm.org>
	<4B85A331.7040909@kernel.org>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Feb_2010_11_22_34_+1100_UJn=YiEKGG_BzgMH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Feb_2010_11_22_34_+1100_UJn=YiEKGG_BzgMH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 24 Feb 2010 14:07:45 -0800 Yinghai Lu <yinghai@kernel.org> wrote:
>
> any guide to setup cross compiling for 22 archs ?
> on x86_64 platform please

There are several cross compilers at http://bakeyournoodle.com/cross/ .
These are only good for building kernels (but, I assume that is all you
need).  Just untar them somewhere useful.

If you have any issues with these, please contact tony@bakeyournoodle.com
(cc'd).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__25_Feb_2010_11_22_34_+1100_UJn=YiEKGG_BzgMH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuFwsoACgkQjjKRsyhoI8yDLwCgosLTHpBphdrOitVnzgowMaQ1
fXwAnimmSLGiKkGpXnd0QfSEK9m+VDoL
=F+qL
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Feb_2010_11_22_34_+1100_UJn=YiEKGG_BzgMH--
