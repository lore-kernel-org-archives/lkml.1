Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbYAPD5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbYAPD5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757294AbYAPD5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:57:08 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51526 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbYAPD5F (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:57:05 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH]PCIE ASPM support - takes 2
In-Reply-To: Your message of "Tue, 15 Jan 2008 13:02:26 +0800."
             <1200373346.20739.4.camel@sli10-desk.sh.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1200373346.20739.4.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200455812_2966P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Jan 2008 22:56:52 -0500
Message-ID: <24456.1200455812@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200455812_2966P
Content-Type: text/plain; charset=us-ascii

On Tue, 15 Jan 2008 13:02:26 +0800, Shaohua Li said:

> In my test, power difference between powersave mode and performance mode
> is about 1.3w in a system with 3 PCIE links.

Do you have any numbers on what the added latency is for powersave mode, and
a rough idea of how quickly chipsets will drop to low-power? It may affect
usability a lot if it's "adds 10ms latency after 100ms idle" or "adds 100ms
latency after 5 seconds idle" or some other pattern...

(The chipset in my laptop claims to be an 82801G with 4 PCI-Express ports on
it - I'm trying to get a rough idea what usage I'd get out of that feature..)

--==_Exmh_1200455812_2966P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHjYCEcC3lWbTT17ARAhAhAJ9ZiY5Uua5IGdHOm05QLsvu8nF0/gCfU0zD
g4w2n3pTVJZEZj7yrIUfvIc=
=41lh
-----END PGP SIGNATURE-----

--==_Exmh_1200455812_2966P--
