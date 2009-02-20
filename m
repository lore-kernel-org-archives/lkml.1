Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZBTSce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZBTSce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbZBTScV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:32:21 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:50390 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755975AbZBTScU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:32:20 -0500
X-Greylist: delayed 1124 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Feb 2009 13:32:19 EST
Message-ID: <499EF28F.4080508@acm.org>
Date: Fri, 20 Feb 2009 11:12:31 -0700
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jan Kara <jack@suse.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: mmotm 2009-02-10-16-35 uploaded (reiser4-quota)
References: <499305AD.4020900@oracle.com>	<20090211171324.GC13817@duck.suse.cz>	<20090212114737.C8EA.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090211185321.138bb93a.akpm@linux-foundation.org>
In-Reply-To: <20090211185321.138bb93a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20090220/1LaZrb-0006GU-Pi-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 12 Feb 2009 11:49:20 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
>> Andrew, recently I've never seen any reiser4 activity in LKML.
>> I would suggest to remove it from -mm.
> 
> A handful of people use it, and the cost of carrying it is pretty low.
> 
> Hey, at least it handles ENOSPC without going BUG().

I use it and love it and I think its code belongs in the kernel far more 
than ext4 ever did when ext4 was first added.

By the way, I have been waiting for a new -mm release. :-)

Are there going to be any more -mm releases or are we supposed to use 
mmotm only now?

-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
