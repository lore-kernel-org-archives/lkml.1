Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYEVQJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYEVQJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYEVQJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:09:37 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:39643 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbYEVQJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:09:35 -0400
Message-ID: <48359A61.6050301@s5r6.in-berlin.de>
Date: Thu, 22 May 2008 18:08:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, tytso@mit.edu, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard	indentation
 of arguments)
References: <12113495282137-git-send-email-kongjianjun@gmail.com> <20080521083413.GM28946@ZenIV.linux.org.uk> <20080521015037.add0b78e.akpm@linux-foundation.org> <20080521103206.GA24545@infradead.org> <20080521120939.GF8581@mit.edu> <20080521104644.5b6f4e63.akpm@linux-foundation.org> <20080521185725.GD6932@cvg> <20080521123127.3b3b66af.akpm@linux-foundation.org> <20080521230155.GC16376@cs181133002.pp.htv.fi>
In-Reply-To: <20080521230155.GC16376@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, May 21, 2008 at 12:31:27PM -0700, Andrew Morton wrote:
>>...
>> For more substantial starter projects the best we have (as far as I
>> know) is http://kernelnewbies.org/KernelProjects, but that's just a
>> teeny subset.
>> 
>> We're not very good at this, I'm afraid.  I seem to recall that Rik has
>> offered to help out here, so perhaps whenever one notices a
>> hey-someone-should-do-this project, it could be forwarded to Rik and he
>> can put it up there.
>>...
> 
> Let's look at it from another angle:
> 
> We should not aim at being good at this.
> 
> What do we need more in the kernel:
> - people testing development kernels
> - people fixing bugs
> - people maintaining code
> - people reviewing code

  - encouragement to develop in the mainline rather than out-of-tree

> What do we already have more than enough:
> - people developing new bugs^Wfeatures

  - companies being content with out-of-tree drivers or even closed
    source drivers or no drivers at all, and users having to put up
    with it
-- 
Stefan Richter
-=====-==--- -=-= =-==-
http://arcgraph.de/sr/
