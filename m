Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbZKOWwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbZKOWwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 17:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbZKOWwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 17:52:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53141 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZKOWwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 17:52:11 -0500
Date: Mon, 16 Nov 2009 09:52:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: PULL request for linux-next
Message-Id: <20091116095210.d518396a.sfr@canb.auug.org.au>
In-Reply-To: <4B002DBE.3010307@kernel.org>
References: <4B002DBE.3010307@kernel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__16_Nov_2009_09_52_10_+1100_nOHiAbXdhp6PI_dl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Nov_2009_09_52_10_+1100_nOHiAbXdhp6PI_dl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Mon, 16 Nov 2009 01:35:10 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> Can you please pull the following tree into linux-next?
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-next
>=20
> Currently, it only contains single patch from Thomas Gleixner to add
> debugobject support in workqueue but I'm planning on pushing
> concurrency managed workqueue patches through the above tree soonish.

Added to linux-next from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Mon__16_Nov_2009_09_52_10_+1100_nOHiAbXdhp6PI_dl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksAhhoACgkQjjKRsyhoI8xGHgCfbTnnD+rOU3AdXa7epYH7f0eX
0n8AoIOqWXy7K0qJH66a2ZJF2wQtZbQP
=p9Rt
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Nov_2009_09_52_10_+1100_nOHiAbXdhp6PI_dl--
