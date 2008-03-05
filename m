Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYCEP6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYCEP6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbYCEP6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:58:22 -0500
Received: from hc65212de.dhcp.vt.edu ([198.82.18.222]:39315 "EHLO
	hc65212de.dhcp.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbYCEP6V (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:58:21 -0500
X-Greylist: delayed 1594 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2008 10:58:21 EST
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/8] driver core: fix up Kconfig text for CONFIG_SYSFS_DEPRECATED
In-Reply-To: Your message of "Tue, 04 Mar 2008 15:18:45 PST."
             <1204672732-3127-1-git-send-email-gregkh@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20080304231519.GC3073@suse.de>
            <1204672732-3127-1-git-send-email-gregkh@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204732693_9212P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Mar 2008 10:58:13 -0500
Message-ID: <18322.1204732693@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204732693_9212P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Mar 2008 15:18:45 PST, Greg Kroah-Hartman said:

> -	  If you are using a distro that was released in 2006 or later,
> -	  it should be safe to say N here.
> +	  If you are using a distro with the most recent userspace
> +	  packages, it should be safe to say N here.

Might want to be a bit more specific here - I *think* udev, lvm, and nash
were the common ones that broke this time around.  Speaking of which,
did anybody rev Documentation/Changes to mention the currently required
releases of stuff?

--==_Exmh_1204732693_9212P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHzsMVcC3lWbTT17ARAlr9AJsHbexS5NLSpCPiVAv9ISXPxGcDJQCg+Bbi
T35IE77whTEy8+rQK/mSbWs=
=sqme
-----END PGP SIGNATURE-----

--==_Exmh_1204732693_9212P--
