Return-Path: <linux-kernel-owner+w=401wt.eu-S934148AbXEWTSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148AbXEWTSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbXEWTSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:18:17 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:38040 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448AbXEWTSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:18:16 -0400
Message-ID: <465492C8.9060003@gmail.com>
Date: Wed, 23 May 2007 21:15:20 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>	<46541F65.9060507@msgid.tls.msk.ru> <20070523100416.93835196.randy.dunlap@oracle.com>
In-Reply-To: <20070523100416.93835196.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2007 07:04 PM, Randy Dunlap wrote:

>> That's a good source of confusion.  To me, "notime" means something
>> like "don't bother calculating time", instead of the proposed
>> behavior.  Can't it be something like 'nologts' (no log timestamps)
>> or nots or notimestamps or nologtime instead?
> 
> "nologtime" is OK with me.  or does it confuse people in a
> different way?  Anyone else?

The CONFIG option is called CONFIG_PRINTK_TIME. How about "noprintktime"? At 
least nicely to the point...

Rene.

