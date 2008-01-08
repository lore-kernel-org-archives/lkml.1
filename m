Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYAHRov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYAHRov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYAHRol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:44:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:63172 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbYAHRok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:44:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,258,1196668800"; 
   d="scan'208";a="280248160"
Message-ID: <4783B602.1050307@linux.intel.com>
Date: Tue, 08 Jan 2008 09:42:26 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Winchester <kjwinchester@gmail.com>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Top 10 kernel oopses for the week ending January 5th, 2008
References: <477FF149.4070609@linux.intel.com>	<20080105213935.GN27894@ZenIV.linux.org.uk>	<20080107174431.GC27741@fieldses.org>	<4782CF9C.6000508@gmail.com>	<alpine.LFD.1.00.0801071851120.3148@woody.linux-foundation.org> <20080108081401.d9576ac5.randy.dunlap@oracle.com>
In-Reply-To: <20080108081401.d9576ac5.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>>
>> (You can do it other and smarter ways too, I'm not claiming that's a 
>> particularly good way to do it, and the old "ksymoops" program used to do 
>> a pretty good job of this, but I'm used to that particular idiotic way 
>> myself, since it's how I've basically always done it)
> 
> One other way to do it (at least for x86-32/64) is to use
> $kerneltree/scripts/decodecode.  It may work on other $arches also,
> but I haven't tested it on others.

I've made life easier for those using the www.kerneloops.org website;
at least for x86 oopses the website now does this for you and shows
the decoded Code: line in the raw oops data:

http://www.kerneloops.org/raw.php?rawid=2716
