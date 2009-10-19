Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZJSIax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZJSIax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZJSIaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:30:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34208 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZJSIaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:30:52 -0400
X-Greylist: delayed 2158 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 04:30:51 EDT
Message-ID: <4ADC1A53.90304@kernel.org>
Date: Mon, 19 Oct 2009 00:50:43 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Sheltren <jeff@osuosl.org>, lance@osuosl.org
CC: "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
Subject: [KORG] Sneaking in an OS upgrade on master.kernel.org - Tue Oct 20
 15:00:00 UTC 2009
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.1.1 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Oct 2009 00:50:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Howdy everyone,

While I've got the chance and master.kernel.org is a little on the quiet
side, what with all the kernel developers off at Kernel Summit in Japan,
I'm going to quietly sneak the distro upgrade for master.kernel.org in
while most of the kernel developers are asleep on the other side of the
planet.

That said this is going to be a two stage upgrade F9 -> F10 -> F11, due
to Fedora moving away from compiling for i386 and to i586 between 10 &
11.  I'm going to plan a 6 hour downtime window, this should encompass
firmware updates and the two upgrade cycles.  I'm not actually expecting
this to take that long but, as with any major OS upgrade, what I don't
expect is what's going to take the longest time.

The downtime window will open on Tue Oct 20 15:00:00 UTC 2009, and will
last until Tue Oct 20 21:00:00 UTC 2009 unless otherwise stated.  If
there are problems or updates expect an e-mail through the same channels
here.

So in summary:

What: Downtime master.kernel.org
When: Tue Oct 20 15:00:00 UTC 2009 - Tue Oct 20 21:00:00 UTC 2009
Why: OS Upgrades and general maintenance

- - John "Warthog9" Hawley
Chief Kernel.org Administrator
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkrcGlMACgkQ/E3kyWU9difq9gCfQFq+Yvm+LOXO6s4Y010tLVeW
EZEAn2P8nycNNtkdWCpAVSAQdfajLFh4
=Guyr
-----END PGP SIGNATURE-----
