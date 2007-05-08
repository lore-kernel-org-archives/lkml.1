Return-Path: <linux-kernel-owner+w=401wt.eu-S969799AbXEHXbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969799AbXEHXbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969697AbXEHXbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:31:40 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:43369 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S969032AbXEHXbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:31:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=nahQRKvHVCTwFV1DDN8jwuvBN+aVVKlewRqjRzCOHNnyPOiHjA6s5oRk7/3ANktju9A3P+PhmLj12d1t+sQqEtsc4lRvqpOOHmyXhwtDHpTHFvezoxcCTirNJSkqgdorQuBk/5DRbMaCFUd03wumHXQZHU4ffe3hbuAuEX5WUkc=  ;
X-YMail-OSG: W0tkfr8VM1n6VzATAbAx2XmHB9XkmqQzwYGa2PIdpdFSjgNS2oWN6dgTb8rXILCv3oIrhMYUUQ--
Message-ID: <46410853.5000704@yahoo.com.au>
Date: Wed, 09 May 2007 09:31:31 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Matt Mackall <mpm@selenic.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6 (was Re:
 Please pull 'libertas' branch of wireless-2.6)
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org> <20070507104117.GA31601@infradead.org> <1178539423.3032.24.camel@localhost.localdomain> <20070507141143.GB5125@tuxdriver.com> <463F443A.5000306@garzik.org> <20070508061255.GT11166@waste.org> <464034C2.3030007@yahoo.com.au> <4640E4CE.1030506@garzik.org>
In-Reply-To: <4640E4CE.1030506@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Nick Piggin wrote:
> 
>> Two things on top of a lot of people's pet peeves list are lack of
>> good review bandwidth, and poor driver code! So it is sad this was
>> merged without Christoph's comments being addressed. "it works for
>> me, we can fix it later" is probably a big reason for quality
>> problems of some parts of the kernel.
>>
>> As for Christoph's idea of perfection... it usually isn't a bad
>> thing. And he is quite reasonable if you explain your good reason
>> to disagree or do something differently. The attitude of ignoring
>> comments can be really demotivating for a reviewer.
> 
> 
> I guess it's a good thing that the maintainer was not ignoring the 
> review comments, then...

My rant was not directed at the driver author...

-- 
SUSE Labs, Novell Inc.
