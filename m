Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965863Ab0BZT2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:28:15 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59804 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965824Ab0BZT2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:28:13 -0500
Message-ID: <4B8820BC.4080300@us.ibm.com>
Date: Fri, 26 Feb 2010 11:27:56 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Antoine Martin <antoine@nagafix.co.uk>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: Source for 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm doing some research into usage of sched_yield() with the hope of 
coming up with some best practices and possibly some improved 
alternatives using futexes. I found the following thread on the subject:

CFS: new java yield graphs
http://lkml.org/lkml/2007/9/25/463

It presents a nice set of data collected regarding various sched_yield() 
scenarios.

http://devloop.org.uk/lkml/

A link to the source was provided, but has since bitrotted as the URL 
brings up a blank page, as does the TLD by itself.

Is there another location now hosting the sources that were here:
http://bugs.devloop.org.uk/devloop/browser/metastores/examples-test/src/com/metastores/examples/perftest/

Perhaps somewhere under this domain?:
http://mts.devloop.org.uk/

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
