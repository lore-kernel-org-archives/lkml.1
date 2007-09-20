Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbXITQJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbXITQJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbXITQJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:09:13 -0400
Received: from pool-71-118-246-34.lsanca.dsl-w.verizon.net ([71.118.246.34]:44775
	"EHLO www.thewybles.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbXITQJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:09:10 -0400
Message-ID: <46F29B4B.2070200@thewybles.com>
Date: Thu, 20 Sep 2007 09:09:47 -0700
From: Charles N Wyble <charles@thewybles.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Andi Kleen <ak@suse.de>, virtualization@lists.linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
References: <1189747054.7262.34.camel@localhost.localdomain> <200709181257.41530.ak@suse.de> <46F02F50.5000001@thewybles.com> <200709182220.27311.ak@suse.de> <46F034A8.2070801@thewybles.com> <alpine.LFD.0.999.0709202110150.18597@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709202110150.18597@enigma.security.iitk.ac.in>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Satyam Sharma wrote:
> 
> On Tue, 18 Sep 2007, Charles N Wyble wrote:
>> Andi Kleen wrote:
>>> Besides it's bad taste and taste is very important.
>> Well it's bad taste for you (one person).
> 
> FWIW, my opinion is the same as Andi's here. Please, let's avoid this
> disease -- unless *absolutely* required, stuff shouldn't be "default y".
> 

I am curious why you think it shouldn't be default why? Bad taste? Can
you provide data about how it will harm things?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG8ptLkQPZV56XDBMRApxNAJwLOv2dabO6KD6t4Z/Fkffelh1IxwCdEzPM
1JEuIQvlkiojgiMy0tnroqk=
=yCiZ
-----END PGP SIGNATURE-----
