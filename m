Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0APLSF (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180Ab0APLSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:18:02 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49040 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0APLSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:18:00 -0500
Date: Sat, 16 Jan 2010 22:17:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Tilman Schmidt <tilman@imap.cc>, David Miller <davem@davemloft.net>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH/REPOST] pci: push deprecated pci_find_device() function
 to last user
Message-Id: <20100116221749.94c6ac32.sfr@canb.auug.org.au>
In-Reply-To: <20100115100830.152bd145@jbarnes-piketon>
References: <20100113142328.5DE2F40107@xenon.ts.pxnet.com>
	<20100113.203338.52448956.davem@davemloft.net>
	<20100114044331.GA29008@suse.de>
	<20100114.001204.203918209.davem@davemloft.net>
	<20100114082823.63379b3d@jbarnes-piketon>
	<20100114221841.D282640108@xenon.ts.pxnet.com>
	<20100115100830.152bd145@jbarnes-piketon>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jan_2010_22_17_49_+1100_MTK6.JsDpK35YUru"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jan_2010_22_17_49_+1100_MTK6.JsDpK35YUru
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 15 Jan 2010 10:08:30 -0800 Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:
>
> Applied to my linux-next branch, thanks Tilman.

Thanks all, this will reduce the x86_64 allmodconfig build warnings by
between 1/3 and 1/2.  (Cheering can be heard all over the IBM Canberra
office :-))

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Jan_2010_22_17_49_+1100_MTK6.JsDpK35YUru
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktRoF4ACgkQjjKRsyhoI8zQhACeJLRn9kx0llzhgtiy9pvyUnQD
FhEAniyQyCeUuOrpcv4ipAErs6iQQF9C
=aUAY
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jan_2010_22_17_49_+1100_MTK6.JsDpK35YUru--
