Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbXFOXd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbXFOXd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbXFOXdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:33:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:50597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbXFOXdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:33:19 -0400
Date: Fri, 15 Jun 2007 16:33:14 -0700
From: Seth Arnold <seth.arnold@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070615233314.GN3564@suse.de>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
	Andreas Gruenbacher <agruen@suse.de>,
	Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FilwpOHBrTVNlmJ3"
Content-Disposition: inline
In-Reply-To: <20070615200623.GA2616@elf.ucw.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--FilwpOHBrTVNlmJ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 15, 2007 at 10:06:23PM +0200, Pavel Machek wrote:
> Yes, you may get some -EPERM during the tree move, but AA has that
> problem already, see that "when madly moving trees we sometimes
> construct path file never ever had".

Pavel, please focus on the current AppArmor implementation. You're
remembering a flaw with a previous version of AppArmor. The pathnames
constructed with the current version of AppArmor are consistent and
correct.

Thanks.

--FilwpOHBrTVNlmJ3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGcyG6+9nuM9mwoJkRAoGcAJ4wV1kEtpmN70ya7EDhAO8C5IzjOACgpgTl
hls0Ny7M+DwqEU17F3MPX3Q=
=o7Ix
-----END PGP SIGNATURE-----

--FilwpOHBrTVNlmJ3--
