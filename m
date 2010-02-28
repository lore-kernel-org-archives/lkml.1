Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031768Ab0B1K1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 05:27:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52371 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031648Ab0B1K1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 05:27:09 -0500
Date: Sun, 28 Feb 2010 21:26:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-Id: <20100228212659.6c32034d.sfr@canb.auug.org.au>
In-Reply-To: <20100228081922.GO30031@ZenIV.linux.org.uk>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	<201002271323.14402.rjw@sisk.pl>
	<20100227124710.GA21164@elte.hu>
	<201002272007.43042.rjw@sisk.pl>
	<20100228071405.GA14205@elte.hu>
	<20100228183725.80915681.sfr@canb.auug.org.au>
	<20100228075105.GC14205@elte.hu>
	<20100228081922.GO30031@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__28_Feb_2010_21_26_59_+1100_fNHx9oiS9WXO3DqU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__28_Feb_2010_21_26_59_+1100_fNHx9oiS9WXO3DqU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Sun, 28 Feb 2010 08:19:22 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> FWIW, it might make sense to run cross-builds for many targets and post
> the things that crop up + analysis to linux-arch...  Any takers?

See http://kisskb.ellerman.id.au/kisskb/branch/9/ ... we just need
someone to read it regularly and post about them.  There is a set of
builds of Linus' tree there as well (look under "Branches").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__28_Feb_2010_21_26_59_+1100_fNHx9oiS9WXO3DqU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuKRPMACgkQjjKRsyhoI8y29wCeLvVO9oC8Vn96WYP+KvnKfzES
uLMAnRqq38u1b6VUccnjO0nWXa9TEtNn
=M0jX
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Feb_2010_21_26_59_+1100_fNHx9oiS9WXO3DqU--
