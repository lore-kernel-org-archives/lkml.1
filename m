Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbXIFVQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbXIFVQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 17:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXIFVQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 17:16:09 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1860 "EHLO myri.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754814AbXIFVQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 17:16:08 -0400
X-Greylist: delayed 2357 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2007 17:16:08 EDT
Message-ID: <46E064C9.9000307@myri.com>
Date: Thu, 06 Sep 2007 16:36:25 -0400
From: Myricom Technical Support <help@myri.com>
Organization: Myricom, Inc.
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: mathieu.desnoyers@polymtl.ca
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Myricom Technical Support <help@myri.com>
Subject: Re: [Myricom help #53553] Re: 2.6.23-rc4-mm1 myri10ge module link
 error on x86_64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu,

>> # CONFIG_INET_LRO is not set

The in-kernel driver now depends on CONFIG_INET_LRO.

The kconfig needs to be changed to reflect this, and we will submit a patch.

In the meantime, you could alternatively use the Myri10GE 1.3.1 driver 
from the download page:
    http://www.myri.com/scs/download-Myri10GE.html

Feel free to contact us if you have additional questions.

Susan


-- 
Susan Blackford
Member of Technical Staff
Myricom Inc.
