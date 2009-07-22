Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbZGVE71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbZGVE71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 00:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZGVE70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 00:59:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53264 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZGVE70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 00:59:26 -0400
Date: Wed, 22 Jul 2009 14:59:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       Christoph Hellwig <hch@infradead.org>, Neil Brown <neilb@suse.de>,
       Nikanth Karthikesan <knikanth@suse.de>, Greg KH <gregkh@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Lars Marowsky-Bree <lmb@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [Drbd-dev] [PATCH 00/16] drbd: a block device for HA clusters
Message-Id: <20090722145917.055eddc1.sfr@canb.auug.org.au>
In-Reply-To: <20090721185156.GA10126@johann>
References: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com>
	<20090720224940.36da1ef8.akpm@linux-foundation.org>
	<20090721185156.GA10126@johann>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__22_Jul_2009_14_59_17_+1000_s8u5PqXttceDOxyO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Jul_2009_14_59_17_+1000_s8u5PqXttceDOxyO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lars,

On Tue, 21 Jul 2009 20:51:56 +0200 Lars Ellenberg <lars.ellenberg@linbit.co=
m> wrote:
>
> Stephen: expect an explicit linux-next merge request
> within the next few days.

OK, just to be clear your tree should be based on Linus' tree (or some
other *stable*, non rebasing, tree - *not* linux-next).

[I guess your tree will fulfill all the following]

What I tell everyone: all patches/commits in the tree/series must
have been:

	posted to a relevant mailing list
	reviewed
	unit tested
	destined for the next merge window (or the current release)

*before* they are included.  The linux-next tree is for integration
testing and to lower the impact of conflicts between subsystems in the
next merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__22_Jul_2009_14_59_17_+1000_s8u5PqXttceDOxyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpmnKUACgkQjjKRsyhoI8ylEACdFd8fg00tm2I4X7PRZHncR502
c28AnRmbPP+Gx4guSTzafXJiwhLnoNSf
=W/NG
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Jul_2009_14_59_17_+1000_s8u5PqXttceDOxyO--
