Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbZFOIl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbZFOIl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFOIlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:41:19 -0400
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:63826 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbZFOIlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:41:18 -0400
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:X-Enigmail-Version:Content-Type:
   Content-Transfer-Encoding;
  b=gmgTu3pHP8i0RMO8RRjQbMj16b/8ImEMkYWBJK7fzty76x7RyoB1ftOr
   CfpuHgfpnsgYpKQp/C76bEEuESpFuRwWugkWptdsx03yWQ7prcgG4GRms
   wTHHoy6nOsptx+qUm7nbITes1M8SelFInqv415565eWBq/1201w0TDR5w
   qFQJ9Y395zLlCPezL52C+R5r6Gz1XfUva8Yb0SSDRGIrGPcRFMLxTYnZR
   53SNV4YekxJ9ExyeqBafu8MjXlxBK;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.42,220,1243807200"; 
   d="scan'208";a="83261120"
X-IronPort-AV: E=Sophos;i="4.42,220,1243807200"; 
   d="scan'208";a="52567975"
Message-ID: <4A36092D.1020805@ts.fujitsu.com>
Date: Mon, 15 Jun 2009 10:41:17 +0200
From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Organization: Fujitsu Technology Solutions
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Chaitanya Lala <clala@riverbed.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regarding patchwork patch #28003
References: <20090611173312.GA7450@clala-laptop> <4A314526.5030704@acm.org>
In-Reply-To: <4A314526.5030704@acm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard wrote:

>> I have been facing the issue of the kipmid's CPU usage spiking since a long time.
>> I have tested the patch sent by Martin (limit CPU time spent in kipmid (version 4)) and it solves the issue for me.
>> I do not see any activity/feedback on the patch.
>> Can I help in some-way to ensure that this patch is merged ?
>>   
> I will add this to the patchset I put out for 2.6.30, and if that goes 
> well it will go into the mainstream kernel.

Thanks a lot!
I suppose the you will choose last version of the patch that I submitted 
(http://marc.info/?l=linux-kernel&m=124414141924616&w=2)

Martin

-- 
Dr. Martin Wilck
PRIMERGY System Software Engineer
x86 Server Engineering

Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn, Germany

Phone:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			martin.wilck@ts.fujitsu.com
Internet:		http://ts.fujitsu.com
Company Details:	http://de.ts.fujitsu.com/imprint.html
