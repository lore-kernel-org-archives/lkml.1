Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbZDXOMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbZDXOMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759509AbZDXOMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:12:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52836 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904AbZDXOMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:12:06 -0400
Date: Sat, 25 Apr 2009 00:11:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>, Sachin Sant <sachinp@in.ibm.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@redhat.com>,
       peterz@infradead.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: Next April 24 : BUG: lock held at task exit time!
Message-Id: <20090425001156.04781613.sfr@canb.auug.org.au>
In-Reply-To: <20090424140445.GL8633@ZenIV.linux.org.uk>
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au>
	<49F1626D.6080102@in.ibm.com>
	<20090424175509.561c96ad.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0904241249180.20196@blonde.anvils>
	<20090424140445.GL8633@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__25_Apr_2009_00_11_56_+1000_20Mo0V88ywKEUH1j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__25_Apr_2009_00_11_56_+1000_20Mo0V88ywKEUH1j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Fri, 24 Apr 2009 15:04:45 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> Applied, will fold on reorder (since Ingo is asking for what will amount
> to reorder anyway).

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__25_Apr_2009_00_11_56_+1000_20Mo0V88ywKEUH1j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknxyKwACgkQjjKRsyhoI8zrOQCeKftgvHyAwioSUsPqttVFONXA
UnIAnRvQjpbBX6SCdzoTe9QEe18DVpSV
=EEhI
-----END PGP SIGNATURE-----

--Signature=_Sat__25_Apr_2009_00_11_56_+1000_20Mo0V88ywKEUH1j--
