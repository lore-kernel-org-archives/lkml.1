Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXCWElN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXCWElN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 00:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933601AbXCWElN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 00:41:13 -0400
Received: from wip-ec-wd.wipro.com ([203.91.193.32]:42305 "EHLO
	wip-ec-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422681AbXCWElM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 00:41:12 -0400
Subject: Re: kmalloc() with size zero
From: Vignesh Babu BM <vignesh.babu@wipro.com>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0703230237390.9555@yvahk01.tjqt.qr>
References: <20070323001824.GA26540@frankl.hpl.hp.com>
	 <Pine.LNX.4.61.0703230237390.9555@yvahk01.tjqt.qr>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 23 Mar 2007 10:09:30 +0530
Message-Id: <1174624770.10742.2.camel@wriver-t81fb058.linuxcoe>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
X-OriginalArrivalTime: 23 Mar 2007 04:41:08.0589 (UTC) FILETIME=[799C29D0:01C76D05]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 07:08 +0530, Jan Engelhardt wrote:
> 
> On Mar 22 2007 16:18, Stephane Eranian wrote:
> >
> I'd say "feature", glibc's malloc also returns an address on
> malloc(0).
> 
This is implementation defined-the standard allows for return of either
null or an address.
> 
> Jan
> --
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
-- 
Regards,  
Vignesh Babu BM  
_____________________________________________________________  
"Why is it that every time I'm with you, makes me believe in magic?"
