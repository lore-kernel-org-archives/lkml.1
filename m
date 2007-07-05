Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbXGESuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbXGESuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759896AbXGESuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:50:10 -0400
Received: from main.gmane.org ([80.91.229.2]:60506 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759136AbXGESuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:50:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
Date: Thu, 05 Jul 2007 14:53:21 -0400
Message-ID: <468D3E21.7070106@tmr.com>
References: <4682411E.6070808@dunaweb.hu> <468ACE27.7030006@dunaweb.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT
X-Complaints-To: usenet@sea.gmane.org
Cc: Kuan Luo <kluo@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peer Chen <pchen@nvidia.com>
X-Gmane-NNTP-Posting-Host: pool-70-109-121-113.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <468ACE27.7030006@dunaweb.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zoltan Boszormenyi wrote:
> Hi,
> 
> Zoltan Boszormenyi írta:
>> Hi,
>>
>> I am testing your current code with akpm's beautifying patches
>> for about an hour now. I have seen no problems with it so far.
> 
> Still using the patch on 2.6.22-rc6 and no problems so far.
> It's really stable. I am looking forward to the next version and
> the inclusion into mainstream kernels. Thanks!
> 
I am going to hold off any more -rc testing, but if there's a patch 
against 2.6.22 when it releases, I would certainly try it on a system 
which is about to be redeploted. I'm also scheduling testing of several 
RAID queueing patches there as well.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

