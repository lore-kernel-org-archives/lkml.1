Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZGUNYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZGUNYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 09:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbZGUNYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 09:24:44 -0400
Received: from fn.samba.org ([216.83.154.106]:49171 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbZGUNYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 09:24:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19045.49553.738185.211806@samba.org>
Date: Tue, 21 Jul 2009 23:24:33 +1000
To: Pavel Machek <pavel@ucw.cz>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <20090721103158.GG4133@elf.ucw.cz>
References: <19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<1247066878.4159.153.camel@mulgrave.site>
	<20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
	<1247069202.4159.212.camel@mulgrave.site>
	<20090708171848.21633768@lxorguk.ukuu.org.uk>
	<873a96a23x.fsf@devron.myhome.or.jp>
	<87hbxhwv0j.fsf@devron.myhome.or.jp>
	<19045.14307.658887.752950@samba.org>
	<4A65875D.7030902@panasas.com>
	<20090721103158.GG4133@elf.ucw.cz>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

 > Actually, why not having dosfsck creating _matching_ short names for
 > long names? As it only writes short names, it should be safe :-).

As I mentioned to Boaz, what usually matters for claim construction in
patents is the overall system. I'm sure John Lanza would be happy to
run through it with you if you want a more legally detailed answer,
but basically breaking it up within the one system isn't likely to
help us.

Like I mentioned to Boaz though, do keep thinking about it. There may
well be a better solution that nobody has suggested yet. You might
also like to read the file wrapper (availble on the USPTO site) which
shows the discussions between the patent office and the
applicant. That is often a good source of inspiration for patent
workarounds. If you think you've found something then it might be a
good idea to raise it with John Lanza first.

Cheers, Tridge
