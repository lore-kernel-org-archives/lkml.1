Return-Path: <linux-kernel-owner+w=401wt.eu-S966195AbXDDGoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966195AbXDDGoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXDDGoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:44:37 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:26258 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753761AbXDDGog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:44:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=gmzjEG8vmVg+9zHTtnEv/cEYY5225RWt9dKFumDtLLIreDRJOdUSV787OwXhePgAgu/4PWfIYCArS7dyO3Hk7paamx7pjHCuYsshtvQCwBMF12FJl119U7YTWfDCtWsdqUbA/ZLrPXXJuknos0JmUvibioe2w12WtW5eglBwG1s=  ;
X-YMail-OSG: IahO760VM1nfAYLgCh22JWUkZcYwW_YwIe.zulBf0m4A4v2_VFPbm21tqyXY3eTeh2UEpIEBVg--
Message-ID: <4613494D.6080401@yahoo.com.au>
Date: Wed, 04 Apr 2007 16:44:29 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patches] threaded vma patches (was Re: missing madvise functionality)
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org> <4612DCC6.7000504@cosmosbay.com> <46130BC8.9050905@yahoo.com.au> <46133A8B.50203@cosmosbay.com> <46134124.2040705@yahoo.com.au> <461348CD.9000200@redhat.com>
In-Reply-To: <461348CD.9000200@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> Nick Piggin wrote:
> 
>>Sad. Although Ulrich did seem interested at one point I think? Ulrich,
>>do you agree at least with the interface that Eric is proposing?
> 
> 
> I have no idea what you're talking about.
> 

Private futexes.

-- 
SUSE Labs, Novell Inc.
