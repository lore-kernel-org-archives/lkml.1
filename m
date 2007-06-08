Return-Path: <linux-kernel-owner+w=401wt.eu-S969300AbXFHPej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969300AbXFHPej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969551AbXFHPdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:33:55 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49980 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969331AbXFHPdx (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:33:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Jones <pjones@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
In-Reply-To: Your message of "Thu, 07 Jun 2007 16:09:04 PDT."
             <20070607230904.GA7344@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <1181228660.3625.23.camel@lov.localdomain> <46682385.1060802@redhat.com> <20070607154342.GA16911@suse.de> <20070607085200.f8d6e2d3.akpm@linux-foundation.org> <20070607155953.GA17591@suse.de> <20070607090632.cfcf02e6.akpm@linux-foundation.org> <20070607161525.GA18363@suse.de> <20070607184805.GA28551@nostromo.devel.redhat.com> <20070607200102.GA21653@suse.de> <20070607233258.063f6cfa@the-village.bc.nu>
            <20070607230904.GA7344@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1181316818_3918P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 08 Jun 2007 11:33:38 -0400
Message-ID: <6712.1181316818@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1181316818_3918P
Content-Type: text/plain; charset=us-ascii

On Thu, 07 Jun 2007 16:09:04 PDT, Greg KH said:
> If CONFIG_SYSFS_DEPRECATED everything should work just fine with all old
> initrd scripts.  It's only if you enable that option (which is enabled
> by default) that you need to ensure that your distro has the latest
> functionality so that everything works properly.

Can somebody document what an initrd has to do differently?  Some of us
run with initrd's not created by mkinitrd.


--==_Exmh_1181316818_3918P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGaXbScC3lWbTT17ARAq/JAJ9dc58XEA5h3oLL+IHoxAeOG6Ky3gCgwZn4
41mh7UQb196vBVimMqZW6HE=
=s9Tp
-----END PGP SIGNATURE-----

--==_Exmh_1181316818_3918P--
