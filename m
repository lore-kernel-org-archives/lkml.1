Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZFZBIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZFZBIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 21:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZFZBIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 21:08:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50032 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZFZBIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 21:08:09 -0400
Date: Fri, 26 Jun 2009 11:08:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Menage <menage@google.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>, jdike@addtoit.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
Message-Id: <20090626110807.19fa161c.sfr@canb.auug.org.au>
In-Reply-To: <6599ad830906250106q2807c72ci21e95b02448ec4f7@mail.gmail.com>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>
	<4A3F4448.30502@panasas.com>
	<20090625135901.a028512d.sfr@canb.auug.org.au>
	<4A432DD4.3010905@panasas.com>
	<6599ad830906250106q2807c72ci21e95b02448ec4f7@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Jun_2009_11_08_07_+1000_t9SnuWg/_WlTw1M2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jun_2009_11_08_07_+1000_t9SnuWg/_WlTw1M2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 25 Jun 2009 01:06:27 -0700 Paul Menage <menage@google.com> wrote:
>
> I split it out into two patches and sent them about an hour ago. (One
> for mmu_context.h sent to Rusty and one for the other two fixes, sent
> to Linus)

Thanks for that.  I see Linus has taken his.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Jun_2009_11_08_07_+1000_t9SnuWg/_WlTw1M2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpEH3cACgkQjjKRsyhoI8wTTQCfYMysBq73UD48BUknm9vXEdNt
1OAAoLc5VHUsQ9M5rZ0eDtiz0qzMJ890
=csOw
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jun_2009_11_08_07_+1000_t9SnuWg/_WlTw1M2--
