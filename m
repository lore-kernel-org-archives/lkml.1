Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYHAQQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYHAQQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYHAQQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:16:14 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:54117 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYHAQQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:16:14 -0400
Message-ID: <489336C7.8010605@linux.vnet.ibm.com>
Date: Fri, 01 Aug 2008 21:46:07 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080724)
MIME-Version: 1.0
To: Tony Breeds <tony@bakeyournoodle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: Re: [BUILD-FAILURE] 2.6.27-rc1-mm1 - allyesconfig build fails on
 powerpc
References: <20080731000354.24b55d5b.akpm@linux-foundation.org> <4891B370.5040208@linux.vnet.ibm.com> <20080801052936.GZ20457@bakeyournoodle.com>
In-Reply-To: <20080801052936.GZ20457@bakeyournoodle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Breeds wrote:
> On Thu, Jul 31, 2008 at 06:13:28PM +0530, Kamalesh Babulal wrote:
>> Hi Andrew,
>>
>> make allyesconfig with 2.6.27-rc1-mm1 kernel on powerpc fails with build error
> 
> <snip>
> 
> Turning off GCOV "fixes" this.  Not really the best solution but at
> least it narrows doen the search effort.

Thanks, kernel compiles after turning off the GCOV profiling options.
> 
> Peter,
> 	Can you have a look at how this can be fixed, if at all?
Peter, 
	kindly let me know if you want me to test any test patches/fixes.
> 
> Yours Tony
> 
>   linux.conf.au    http://www.marchsouth.org/
>   Jan 19 - 24 2009 The Australian Linux Technical Conference!
> 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
