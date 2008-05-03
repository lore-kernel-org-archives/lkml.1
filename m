Return-Path: <linux-kernel-owner+w=401wt.eu-S934990AbYECBU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934990AbYECBU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 21:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761426AbYECBUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 21:20:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51629 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbYECBUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 21:20:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <481BBD84.10904@s5r6.in-berlin.de>
Date: Sat, 03 May 2008 03:19:00 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-next@vger.kernel.org, sfrench@us.ibm.com, swhiteho@redhat.com,
       jeff@garzik.org, ralf@linux-mips.org, drzeus-list@drzeus.cx,
       jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com, ericvh@gmail.com,
       wim@iguana.be, chris@zankel.net, nico@cam.org, penberg@cs.helsinki.fi,
       clameter@sgi.com, ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
References: <20080502151206.b40f77ea.akpm@linux-foundation.org> <20080502154200.a6d8c43a.akpm@linux-foundation.org>
In-Reply-To: <20080502154200.a6d8c43a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 2 May 2008 15:12:06 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> The first
>> problem is working out "how the heck did that patch get into linux-next"? 
>> That would be much easier if the signoff trail was complete for git-based
>> patches, but it often is not.
> 
> doh.  I'm pulling linux-next's constituent trees independently, so if I
> spot a turd in linux-next I can just grep the various git trees to find out
> where it came from.
> 
> It seems wrong though...

What about the committer info?  Well, I suppose a nobody@localhost slips 
in, but more often I expect it to be something more telling than that.
-- 
Stefan Richter
-=====-==--- -=-= ---==
http://arcgraph.de/sr/
