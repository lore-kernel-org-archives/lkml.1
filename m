Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYDESUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYDESUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 14:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYDESUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 14:20:11 -0400
Received: from main.gmane.org ([80.91.229.2]:43837 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbYDESUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 14:20:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.25-rc7: Ugh.
Date: Sat, 05 Apr 2008 14:23:12 -0400
Message-ID: <47F7C390.3080108@tmr.com>
References: <20080327.201202.163153963.davem@davemloft.net>	<20080328044258.7AA98DBA2@gherkin.frus.com> <20080327.215622.103233305.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-usb@vger.kernel.org
X-Gmane-NNTP-Posting-Host: pool-68-236-140-141.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20080327.215622.103233305.davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: rct@frus.com (Bob Tracy)
> Date: Thu, 27 Mar 2008 23:42:58 -0500 (CDT)
> 
>> I don't understand this claim.  On what incredibly fast piece of iron
>> can you possibly do between 8 and 16 kernel builds (the range I've
>> encountered when I do the "git bisect" dance), boot each one, and
>> evaluate the results in so small a period of time?
> 
> Builds are just over a minute on my box.  I can do a full
> kernel build plus reboot cycle in under 2 minutes.
> 
Most of us got over "mine is bigger than yours" bragging at about age 
13. He said "laptop," that means slow builds, slow installs, slow boots, 
and unless he's on a fat net pipe to a faster machine, build elsewhere 
isn't much of a saving.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

