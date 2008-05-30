Return-Path: <linux-kernel-owner+w=401wt.eu-S1757762AbYE3AZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbYE3AZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 20:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYE3AZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 20:25:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56063 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYE3AZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 20:25:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <483F4947.40201@s5r6.in-berlin.de>
Date: Fri, 30 May 2008 02:24:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Jiri Kosina <jkosina@suse.cz>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org, penberg@cs.helsinki.fi,
       dwmw2@infradead.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
References: <1212010931.3445.103.camel@localhost.localdomain> <1212013125.2236.58.camel@shinybook.infradead.org> <1212014127.3445.115.camel@localhost.localdomain> <20080528.230934.131215087.davem@davemloft.net> <1212071813.3428.22.camel@localhost.localdomain> <Pine.LNX.4.64.0805291656000.6718@jikos.suse.cz> <20080529163247.GW22636@parisc-linux.org>
In-Reply-To: <20080529163247.GW22636@parisc-linux.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, May 29, 2008 at 05:06:15PM +0200, Jiri Kosina wrote:
>> All I want to say is that I could very well imagine that a lot of 
>> newcomers will find "hey, feel free to crawl through bugzilla and fix 
>> whatever you are able to fix" very non-attractive.
> 
> Of course.  We have to make it sexier than that.

A newcomer is motivated to fix a non-trivial bug if his own setup is 
seriously affected, no convenient workaround is possible, and it is 
clear that nobody else is gong to fix the bug (e.g. because the code is 
orphaned).

If you have funds, you may have ways to provide better motivators than this.
-- 
Stefan Richter
-=====-==--- -=-= ====-
http://arcgraph.de/sr/
