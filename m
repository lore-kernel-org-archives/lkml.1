Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYDJHoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYDJHoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 03:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYDJHo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 03:44:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53348 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbYDJHoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:44:25 -0400
Date: Thu, 10 Apr 2008 17:44:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 9
Message-Id: <20080410174418.ebfe76c3.sfr@canb.auug.org.au>
In-Reply-To: <20080410065227.GB30066@elte.hu>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au>
	<47FCF50E.9090703@s5r6.in-berlin.de>
	<20080410065227.GB30066@elte.hu>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Apr_2008_17_44_18_+1000_xFXuyCfHOoJkys_4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Apr_2008_17_44_18_+1000_xFXuyCfHOoJkys_4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Apr 2008 08:52:27 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> what type of conflict do you have there? If it's a new entry then you=20
> might be able to fix it by moving the new entry elsewhere in the file.=20
> Or if i introduced a new entry close to an existing entry you modify=20
> then i could move my new entry elsewhere.

Commit 523a65f1a7a339e528ca6d6d808516fe195fde03 ("firewire: fw-ohci: add
option for remote debugging") in the ieee1394 tree adds a new entry just
where the sched tree adds

source kernel/trace/Kconfig

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Apr_2008_17_44_18_+1000_xFXuyCfHOoJkys_4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH/cVWTgG2atn1QN8RAlyWAKCGG7rORWKNOxi28nrGVoZIaEWNgACgjrjA
+aBefjDyyvGTm+yeWk1GoDQ=
=tqoi
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Apr_2008_17_44_18_+1000_xFXuyCfHOoJkys_4--
