Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXC2NoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXC2NoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbXC2NoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:44:14 -0400
Received: from mail.tmr.com ([64.65.253.246]:52366 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbXC2NoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:44:13 -0400
Message-ID: <460BC2B1.1000806@tmr.com>
Date: Thu, 29 Mar 2007 09:44:17 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod
 doesn't work
References: <20070326204744.GA24762@dose.home.local> <Pine.LNX.4.44L0.0703261712340.7079-100000@iolanthe.rowland.org> <20070326213157.GA3034@dose.home.local>
In-Reply-To: <20070326213157.GA3034@dose.home.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel wrote:
> On Mon, Mar 26, 2007 at 17:15:53 -0400, Alan Stern wrote:
> 
> [...]
> 
>> The lack of messages from the iPod seems to indicate that the hub isn't
>> working right.  You could try plugging the iPod into a different hub or
>> directly into the computer.  Or maybe into a different port of that hub.
> 
> Uh, I think I found the reason for the strange behaviour at
> shutdown/suspend. When I unload the usblp module, then the iPod is
> recognized.
> 
And that's not the case with 2.6.20?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
