Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbYADUBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbYADUBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYADUBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:01:45 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:35320 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYADUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:01:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TiEAoO8P4ssrxIse+ILLUfa9fhs3E5jm58kl4GUtouaw1+eEgBh7qFH1qJPao18aOSCKvAB8xzaqta1ZyqzR8NijiOH65rDI2hItMkOlaxsJp43NcGyJD51E8a5N5lqQNcCr4LKzDfMR+3LYZUZ/6vUTX5v22pornhVKFIY5gw4=
Date: Fri, 4 Jan 2008 23:01:25 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Theodore Tso <tytso@mit.edu>, Mathieu Segaud <mathieu.segaud@regala.cx>,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h}
	from checkpatch.pl
Message-ID: <20080104200125.GA21486@cvg>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <20080104134458.GE17436@mit.edu> <p73hcht8sfr.fsf@bingen.suse.de> <20080104190137.GJ17436@mit.edu> <20080104194129.GA16962@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104194129.GA16962@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andi Kleen - Fri, Jan 04, 2008 at 08:41:29PM +0100]
[...snip...] 
| My hope here is of course that these trivial changes are primarily
| used as a way to get "the feet wet" to understand the procedures
| for contribuing larger not quite as trivial changes
| 
| -Andi
| 
| P.S.: Mathieu, this is not against you personally; you just happened
| to be a convenient example of a larger problem in this case. Sorry.
| 

Oh, Andi, you're so right! I don't like to admit that, but you're
right (in my case at least). I counted four clean-up patches I sent
since last 'really bug fix' I made patch. Actually I thought that
really helps the kernel but it seems it doesn't and causes more
problem with patch applience (unfortunately).

		- Cyrill -
