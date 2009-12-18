Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZLRQ7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZLRQ7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZLRQ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:59:40 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:58600 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbZLRQ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:59:39 -0500
Date: Fri, 18 Dec 2009 08:58:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       Joe Perches <joe@perches.com>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Mikulas Patocka <mpatocka@redhat.com>,
       Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Re: [PATCH] scripts/checkpatch.pl: Change long line
 warning to 105 chars
Message-Id: <20091218085858.029c5660.randy.dunlap@oracle.com>
In-Reply-To: <20091218151241.GD9334@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost>
	<1261113144.13734.317.camel@Joe-Laptop.home>
	<m3iqc41h83.fsf@intrepid.localdomain>
	<20091218151241.GD9334@agk-dp.fab.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B2BB4DA.0036:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 15:12:41 +0000 Alasdair G Kergon wrote:

> On Fri, Dec 18, 2009 at 03:37:00PM +0100, Krzysztof Halasa wrote:
> > Not sure if that's long enough (maybe it is).
> > 132 looks like the next "natural" number.
> 
> Well it's good that this thread has produced more examples where it's
> reasonable and acceptable to exceed 80 characters.
> 
> What do people feel about files where the policy is to place all the
> parameters passed into a function on the same line, regardless of its
> consequent length?  

Not good IMO.  It's much easier to read something that is restricted in
width than to have to scroll/pan side to side.
(e.g., newspaper columns.  Oops, what's a newspaper?)


> (What kicked this all off was a patch Mikulas submitted containing many
> long lines, one of which hits column 264.  Personally, I dislike reading
> code with lines that wrap, but using a 132-column terminal width is
> fine.)


---
~Randy
