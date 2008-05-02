Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbYEBHlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbYEBHlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYEBHlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:41:07 -0400
Received: from hosted06.westnet.com.au ([203.10.1.221]:46900 "EHLO
	hosted06.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYEBHlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:41:06 -0400
X-Greylist: delayed 1298 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 03:41:05 EDT
Message-ID: <481AC07A.6080707@snapgear.com>
Date: Fri, 02 May 2008 17:19:22 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: ColdFire add support for kernel preemption
References: <200805010216.m412GT6t004096@goober> <20080501143336.552e39e1.akpm@linux-foundation.org>
In-Reply-To: <20080501143336.552e39e1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

Andrew Morton wrote:
> On Thu, 1 May 2008 12:16:29 +1000
> Greg Ungerer <gerg@snapgear.com> wrote:
> 
>> Subject: [PATCH] m68knommu: ColdFire add support for kernel preemption
> 
> Please find a way to get your patch queue into linux-next so that others
> get some visibility into what you're brewing earlier than
> last-day-of-the-merge-window?

Is a git tree the only way?


> Also, when emailing patches like this I do think that it's best that they
> be sequence-numbered, even if they are all non-overlapping and unrelated. 
> Because it allows the recipient to check that none got lost.

Ok.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
