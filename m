Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZCYIOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZCYIOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZCYINl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:13:41 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35040 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbZCYINk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:13:40 -0400
X-Greylist: delayed 3197 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2009 04:13:39 EDT
Message-ID: <49C9D99D.2050400@eaglescrag.net>
Date: Wed, 25 Mar 2009 00:13:33 -0700
From: "J.H." <warthog19@eaglescrag.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       support@osuosl.org, Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Martin Bligh <mbligh@mbligh.org>, "Jorge O. Castro" <jorge@ubuntu.com>,
       bugme-admin@linux-foundation.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
CC: Jim Zemlin <jzemlin@linux-foundation.org>
Subject: [KORG] Bugzilla Upgrade / Server move
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.1.1 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Mar 2009 00:13:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Evening Everyone,

Just a quick heads up to everyone http://bugzilla.kernel.org was taken
down for about an hour this evening to perform an upgrade that was
precipitated by a possible security vulnerability that we wanted to
squash quickly and avoid it going forward.

The code base has had a rather extensive upgrade, migrating custom
fields over to Bugzilla's 3.x custom field support, and dealing with
kernel.org specific changes.

Along with this upgrade http://bugzilla.kernel.org has moved onto the
kernel.org dynamic hosting machine, joining patchwork and our wikis on
this dedicated piece of hardware.

If you have any issues, problems, concerns, please don't hesitate to get
a hold of me, ftpadmin@kernel.org and/or bugme-admin@linux-foundation.org

- - John 'Warthog9' Hawley
Chief Kernel.org Administrator
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAknJ2Z0ACgkQ/E3kyWU9didIjQCfcIkjMhbc1TvqlMPAjgwDFk8p
orEAnAtJWGMfZJNuawlxSuRTBDbcGFcD
=0IE9
-----END PGP SIGNATURE-----
