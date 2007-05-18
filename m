Return-Path: <linux-kernel-owner+w=401wt.eu-S1759768AbXERDcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768AbXERDcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 23:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbXERDcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 23:32:05 -0400
Received: from sandeen.net ([209.173.210.139]:21290 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbXERDcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 23:32:05 -0400
Message-ID: <464D1E32.6060708@sandeen.net>
Date: Thu, 17 May 2007 22:32:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
References: <20070516144205.GV26766@think.oraclecorp.com> <Pine.LNX.4.61.0705162010370.9019@yvahk01.tjqt.qr> <464B57B7.7090404@garzik.org>
In-Reply-To: <464B57B7.7090404@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jan Engelhardt wrote:
>> On May 16 2007 10:42, Chris Mason wrote:
>>> For example, I'll pick on xfs for a minute.  compilebench shows the
>>> default FS you get from mkfs.xfs is pretty slow for untarring a bunch of
>>> kernel trees.
>>
>> I suppose you used 'nobarrier'? [ http://lkml.org/lkml/2006/5/19/33 ]
> 
> Shouldn't that option be renamed to 'corrupt_my_data'?  ;-)

It means "I have real storage with battery backed cache and I'd like 
good performance, please"

-Eric
