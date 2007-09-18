Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbXIRUER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbXIRUER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXIRUED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:04:03 -0400
Received: from pool-71-118-246-34.lsanca.dsl-w.verizon.net ([71.118.246.34]:40136
	"EHLO www.thewybles.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbXIRUEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:04:01 -0400
Message-ID: <46F02F50.5000001@thewybles.com>
Date: Tue, 18 Sep 2007 13:04:32 -0700
From: Charles N Wyble <charles@thewybles.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: virtualization@lists.linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
References: <1189747054.7262.34.camel@localhost.localdomain>	<1189747124.7262.36.camel@localhost.localdomain>	<1189747280.7262.39.camel@localhost.localdomain> <200709181257.41530.ak@suse.de>
In-Reply-To: <200709181257.41530.ak@suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Andi Kleen wrote:
> On Friday 14 September 2007 07:21, Rusty Russell wrote:
>> It's pretty widely used,
> 
> Is it? By whom?
> 
>> and the distributions will turn it on. 
> 
> That's no reason to make it default y. Please undo that. default y
> is near always a bad idea.


Andi,

	What do you base this on? Why is making something default y a bad idea?
Those most likely to care can turn it off. Is there a harmful effect
from leaving it on if its not being used?



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG8C9QkQPZV56XDBMRAowcAJ9fkxKAjjsvGd6hOPkvHXU9ThpoQwCdGUI8
mjpUh6G+ZyzL0CW3sYNS97g=
=ZgiJ
-----END PGP SIGNATURE-----
