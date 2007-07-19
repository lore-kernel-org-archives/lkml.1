Return-Path: <linux-kernel-owner+w=401wt.eu-S965740AbXGSRKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965740AbXGSRKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940350AbXGSRJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:09:12 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:49898 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S940342AbXGSRJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:09:09 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.22-git: known regressions with patches
Date: Thu, 19 Jul 2007 20:08:09 +0300
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Giacomo Catenazzi <cate@cateee.net>, Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jens Axboe <axboe@suse.de>,
       "Peter M. Jones" <pjones@redhat.com>,
       Larry Finger <Larry.Finger@lwfinger.net>, Meelis Roos <mroos@linux.ee>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
References: <469F92B8.5090809@googlemail.com>
In-Reply-To: <469F92B8.5090809@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3915519.YtECA2XLpR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707192008.15147.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3915519.YtECA2XLpR
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Michal;

19 Tem 2007 Per tarihinde, Michal Piotrowski =C5=9Funlar=C4=B1 yazm=C4=B1=
=C5=9Ft=C4=B1:=20
> Block layer
>
> Subject         : bsg.c:(.init.text+0x43d): undefined reference to
> `scsi_register_interface' References      :
> http://lkml.org/lkml/2007/7/16/343
> Last known good : ?
> Submitter       : Larry Finger <Larry.Finger@lwfinger.net>
> Caused-By       : ?
> Handled-By      : S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
> Patch           : http://lkml.org/lkml/2007/7/16/380
> Status          : patch available

After a off-list discussion this was solved with Linus's commit [1], so ple=
ase=20
drop that one

[1]=20
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
it;h=3D29417b899a77aaba1c060f5e123db4f50006f58a

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart3915519.YtECA2XLpR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGn5p+y7E6i0LKo6YRAowhAKDUsRQBQpbQp7lgebGtEYI44np7hwCfbRpq
byayx/iQGIhdU7aGZXDOErA=
=tmqV
-----END PGP SIGNATURE-----

--nextPart3915519.YtECA2XLpR--
