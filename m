Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbXJGUF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbXJGUF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 16:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbXJGUFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 16:05:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54878 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914AbXJGUFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 16:05:10 -0400
Message-ID: <47093BEC.2010000@garzik.org>
Date: Sun, 07 Oct 2007 16:05:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: netdev@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/5] forcedeth: several proposed updates for testing
References: <20071006151250.GA17020@havoc.gtf.org>	 <4708F194.7080303@garzik.org> <86802c440710071239x28c41db2hca6dd7c5bb3c411c@mail.gmail.com>
In-Reply-To: <86802c440710071239x28c41db2hca6dd7c5bb3c411c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On 10/7/07, Jeff Garzik <jeff@garzik.org> wrote:
>> Jeff Garzik wrote:
>>> The 'fe-lock' branch of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git fe-lock
>> OK, I've successfully tested patches 1-5 on an AMD64 system with
>>
>> 00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
> 
> need to test that with mcp55 based, that will use MSI.

I would love to see an MSI-X test too (might have to turn on throughput 
mode).

	Jeff



