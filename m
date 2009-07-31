Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZGaCB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZGaCB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 22:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZGaCBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 22:01:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41595 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbZGaCBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 22:01:55 -0400
Date: Fri, 31 Jul 2009 12:01:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: linux-next: manual merge of the edac-amd tree with the rr tree
Message-Id: <20090731120146.00980017.sfr@canb.auug.org.au>
In-Reply-To: <20090730110938.GA16659@aftab>
References: <20090730154150.d4c326b5.sfr@canb.auug.org.au>
	<20090730062309.GA15057@liondog.tnic>
	<20090730170850.6d777e96.sfr@canb.auug.org.au>
	<20090730110938.GA16659@aftab>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__31_Jul_2009_12_01_46_+1000_Ev8A6JTi7C7ISAIh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__31_Jul_2009_12_01_46_+1000_Ev8A6JTi7C7ISAIh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boris,

On Thu, 30 Jul 2009 13:09:39 +0200 Borislav Petkov <borislav.petkov@amd.com=
> wrote:
>
> I rediffed the topology bits against
> cpumask:remove-topology_core_siblings-and-topology_thread_siblings-core.
> patch from Rusty's tree so we should be good to go.

Thanks.

> Also, I'm carrying couple of patches that should go through the x86 tree
> and depending on when they go in, I'll drop them from mine. Just wanted
> to give you heads up here in case you start getting merge conflicts :).

OK

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__31_Jul_2009_12_01_46_+1000_Ev8A6JTi7C7ISAIh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpyUIoACgkQjjKRsyhoI8yVxgCcCTF77Bkk8NjCIcGeoybGKrlJ
SFsAoINyh5LEbmV5+u6qGahWdY2bfC0v
=V+9K
-----END PGP SIGNATURE-----

--Signature=_Fri__31_Jul_2009_12_01_46_+1000_Ev8A6JTi7C7ISAIh--
