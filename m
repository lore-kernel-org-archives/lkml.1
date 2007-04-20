Return-Path: <linux-kernel-owner+w=401wt.eu-S2992546AbXDTIsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992546AbXDTIsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992551AbXDTIsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:48:32 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33114 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992546AbXDTIsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:48:32 -0400
Message-ID: <46287DD1.7020007@bull.net>
Date: Fri, 20 Apr 2007 10:46:09 +0200
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] fix undefined symbol if CONFIG_PAGE_GROUP_BY_MOBILITY
 not set
References: <20070420100744.cd287042.Pierre.Peiffer@bull.net> <Pine.LNX.4.64.0704200940460.6816@skynet.skynet.ie>
In-Reply-To: <Pine.LNX.4.64.0704200940460.6816@skynet.skynet.ie>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/04/2007 10:51:08,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/04/2007 10:51:10,
	Serialize complete at 20/04/2007 10:51:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi,
> 
> Your fix looks correct but the compile-time option 
> CONFIG_PAGE_GROUP_BY_MOBILITY was removed in a patch I sent to Andrew 
> two days ago. It went into mm-commits last night so this problem should 
> no longer exist.

Ah ok, fine. Just forget it in this case :)
Thanks,

-- 
Pierre
