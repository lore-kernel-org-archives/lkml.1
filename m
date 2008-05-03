Return-Path: <linux-kernel-owner+w=401wt.eu-S964943AbYECBPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964943AbYECBPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 21:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763080AbYECBPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 21:15:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51467 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761426AbYECBPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 21:15:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <481BBBBD.9060709@s5r6.in-berlin.de>
Date: Sat, 03 May 2008 03:11:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-next@vger.kernel.org, Steven French <sfrench@us.ibm.com>,
       Steven Whitehouse <swhiteho@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Pierre Ossman <drzeus-list@drzeus.cx>, Jan Kara <jack@ucw.cz>,
       Anton Vorontsov <cbou@mail.ru>, Jens Axboe <jens.axboe@oracle.com>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Wim Van Sebroeck <wim@iguana.be>, Christian Zankel <chris@zankel.net>,
       Nicolas Pitre <nico@cam.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
In-Reply-To: <20080502151206.b40f77ea.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> git-ieee1394: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git#for-mm

Stephen pulls linux1394-2.6.git#for-next.

> Guys, could you please prepare a tree for Stephen and send the details
> over to him?  Please Cc me also.
> 
> Once this has happened, there should be no need to run a separate for-mm
> branch.  I'll just switch over to using whatever branch linux-next is
> using.

-mm is going to become identical in content to -next?
-- 
Stefan Richter
-=====-==--- -=-= ---==
http://arcgraph.de/sr/
