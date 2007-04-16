Return-Path: <linux-kernel-owner+w=401wt.eu-S1030876AbXDPQsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030876AbXDPQsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965397AbXDPQsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:48:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62928 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345AbXDPQsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:48:06 -0400
Message-ID: <4623A93F.7060307@oracle.com>
Date: Mon, 16 Apr 2007 09:50:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andreas Gruenbacher <agruen@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
Subject: Re: [nameidata 2/2] Pass no useless nameidata to the create, lookup,
 and permission IOPs
References: <20070412090809.917795000@suse.de> <200704161829.20669.agruen@suse.de> <20070416094225.2616c4b6.randy.dunlap@oracle.com> <200704161844.39007.agruen@suse.de>
In-Reply-To: <200704161844.39007.agruen@suse.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Gruenbacher wrote:
> On Monday 16 April 2007 18:42, Randy Dunlap wrote:
>> Please don't use the kernel-doc begin-marker "/**" when the comment block
>> isn't in kernel-doc format.
> 
> Sigh, kernel-doc should improve things, not get in the way ...

Well, I see it as sort of a language that is embedded in C source code.

But what are you suggesting?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
