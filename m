Return-Path: <linux-kernel-owner+w=401wt.eu-S1031188AbXD1T2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031188AbXD1T2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031201AbXD1T2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:28:09 -0400
Received: from mail.tmr.com ([64.65.253.246]:49334 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031188AbXD1T2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:28:05 -0400
Message-ID: <4633A0A9.7090105@tmr.com>
Date: Sat, 28 Apr 2007 15:29:45 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: ck@vds.kolivas.org, linux-kernel@vger.kernel.org
Subject: Re: Best CONFIG_HZ value for scheduler testing?
References: <200704271044.13916.Martin@lichtvoll.de>
In-Reply-To: <200704271044.13916.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> Hi Con and Ingo!
> 
> What would be the best CONFIG_HZ value for scheduler testing? I used 
> 1000HZ for a long time, but use 300HZ since 2.6.20. This worked well 
> enough for sd-0.46 and previous versions and ck patches...
> 
That's a good point, all the tests I've done are at 1000, that's just my 
default and I didn't bother to change it.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
