Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbZD2OSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbZD2OSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZD2OS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:18:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56313 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbZD2OS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:18:27 -0400
Date: Thu, 30 Apr 2009 00:18:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com,
       Eric.Moore@lsi.com, stern@rowland.harvard.edu,
       fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com,
       Geert.Uytterhoeven@sonycom.com, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net,
       jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
       dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
       davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, bharrosh@panasas.com
Subject: Re: [PATCH 04/10] block: implement blk_rq_pos/[cur_]sectors() and
 convert obvious ones
Message-Id: <20090430001810.56532d81.sfr@canb.auug.org.au>
In-Reply-To: <1240996428-10159-5-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
	<1240996428-10159-5-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Apr_2009_00_18_10_+1000_Q/N_cTYXHDeMPz2a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Apr_2009_00_18_10_+1000_Q/N_cTYXHDeMPz2a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Apr 2009 18:13:42 +0900 Tejun Heo <tj@kernel.org> wrote:
>
>  drivers/block/viodasd.c         |    6 +++---

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Apr_2009_00_18_10_+1000_Q/N_cTYXHDeMPz2a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn4YaIACgkQjjKRsyhoI8z6NgCguZNob2wlgTAvYTg3ah/OkVmx
HvoAoJcf4e9uOB1DDN0or2FMJWCwOPkH
=+4Zr
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Apr_2009_00_18_10_+1000_Q/N_cTYXHDeMPz2a--
