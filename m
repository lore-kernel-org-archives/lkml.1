Return-Path: <linux-kernel-owner+w=401wt.eu-S935753AbXHIGb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935753AbXHIGb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761258AbXHIGbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:31:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55914 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759068AbXHIGbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:31:18 -0400
Message-ID: <46BAB4AF.7010001@garzik.org>
Date: Thu, 09 Aug 2007 02:31:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, gallatin@myri.com, stefan.roscher@de.ibm.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/1] lro: Generic Large Receive Offload for TCP traffic
References: <200708031441.14780.ossthema@de.ibm.com> <20070808.231144.22645124.davem@davemloft.net>
In-Reply-To: <20070808.231144.22645124.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jan-Bernd Themann <ossthema@de.ibm.com>
> Date: Fri, 3 Aug 2007 14:41:14 +0200
> 
>> I think this patch could be the final version for now. It has been tested
>> on two platforms (power and x86_64) and works very well.
> 
> I checked in the LRO patch and the two sample driver ports
> to net-2.6.24, thanks!

Good to hear, thanks all.

I'll ponder whether I want to rebase netdev-2.6.git#upstream (2.6.24 
queue) on top of net-2.6.24.  I might put it off until the pain 
threshold rises, or I might go ahead and do it.  Undecided.

Either way, I'll want you to push to Linus before I do, when the next 
merge window opens.

	Jeff



