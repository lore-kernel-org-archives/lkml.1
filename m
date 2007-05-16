Return-Path: <linux-kernel-owner+w=401wt.eu-S1762356AbXEPRa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762356AbXEPRa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbXEPRaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:30:13 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:38928 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755781AbXEPRaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:30:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Yf3fVbGmPHACcpD780mNDjF0b7NkM77+lBKPByhxACLyUpKt8NPOgHDmd3hnvNUggSRQfQ5LxngKV74DVdSLLQgd77cGWv2yixQJpK7TqfmQZX/AF2efbg+wuBEz4GYo+4jZ6ADAGVUUXUvY26SJSYzx4fww/G6zqbL/COLG3mY=  ;
X-YMail-OSG: 6lG7j9UVM1lVAqqBv77ecd6iFM6xTJSUS4szCwjYr9eQ4GrL5fvNnJ2uTr7RbUDqd7Iv9txhgg--
Message-ID: <464B3F9D.7020102@yahoo.com.au>
Date: Thu, 17 May 2007 03:30:05 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] AFS: Implement shared-writable mmap
References: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com> <20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com> <20070515144007.f87d9be5.akpm@linux-foundation.org> <464A533B.8040507@yahoo.com.au> <Pine.LNX.4.64.0705161711090.7914@blonde.wat.veritas.com> <464B3BE4.10704@yahoo.com.au> <Pine.LNX.4.64.0705161823550.16760@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0705161823550.16760@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 17 May 2007, Nick Piggin wrote:
> 
>>... and I don't want to change the
>>VM in a way that people are not unhappy with :)
> 
> 
> I'm hoping you intended one less negative ;)

Derrr... I'm an idiot!

-- 
