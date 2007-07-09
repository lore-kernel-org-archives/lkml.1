Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbXGISA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbXGISA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXGISAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:00:51 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:35482 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbXGISAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:00:49 -0400
Message-ID: <469277C8.3040107@dgreaves.com>
Date: Mon, 09 Jul 2007 19:00:40 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>, Mark Lord <liml@rtr.ca>,
       Douglas Gilbert <dougg@torque.net>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: Re: SMART problems in 2.6.22
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu> <4692221B.7050608@dgreaves.com> <Pine.LNX.4.63.0707091236530.7386@trinity.phys.uwm.edu>
In-Reply-To: <Pine.LNX.4.63.0707091236530.7386@trinity.phys.uwm.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bruce Allen wrote:
> Hi David,
> 
>>> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg164863.html
> 
>> This is mine and although it's a 'real' problem, it is something 
>> that's easy to hack around by having the suspend script turn on smart 
>> after it is resumed. (Of course I can't use resume until a skge wol 
>> bug is fixed so I won't see/test this unless asked too.)
>>
>> The smart init scripts run '-s on' when the system boots anyway for my 
>> system - this problem only occurs for me during suspend/resume. Maybe 
>> smartd should detect that as Alan says.
> 
> OK, that should be easy to do.  So let's forget about the 'SMART 
> disabled' issue.  This is easy to fix in multiple ways and is not a LKML 
> issue.
Sure.


> David: can you reproduce the more serious problem 
> http://article.gmane.org/gmane.linux.utilities.smartmontools/4712 
> reported by Jan Dvorak?
Sorry, I haven't seen that problem.

David
