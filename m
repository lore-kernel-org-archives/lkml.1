Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbZLRWgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbZLRWgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932737AbZLRWgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:36:31 -0500
Received: from khc.piap.pl ([195.187.100.11]:37099 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558AbZLRWg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:36:28 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       Joe Perches <joe@perches.com>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Re: [PATCH] scripts/checkpatch.pl: Change long line warning to 105 chars
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost>
	<1261113144.13734.317.camel@Joe-Laptop.home>
	<m3iqc41h83.fsf@intrepid.localdomain>
	<20091218151241.GD9334@agk-dp.fab.redhat.com>
	<20091218085858.029c5660.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0912181210130.3223@hs20-bc2-1.build.redhat.com>
Date: Fri, 18 Dec 2009 23:36:25 +0100
In-Reply-To: <Pine.LNX.4.64.0912181210130.3223@hs20-bc2-1.build.redhat.com>
	(Mikulas Patocka's message of "Fri, 18 Dec 2009 12:12:34 -0500 (EST)")
Message-ID: <m3oclvzz86.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> I don't like scrolling too but most viewers and editors wrap it 
> automatically to screen width. For example, restrict your terminal to 50 
> columnts and try using "less".

It's the tools.

I think it's much easier to fix tools ("smart wrap") than to rewrite the
source.
-- 
Krzysztof Halasa
