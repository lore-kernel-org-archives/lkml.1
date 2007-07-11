Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbXGKHrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbXGKHrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXGKHq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:46:59 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:32827 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751221AbXGKHq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:46:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=RaBa3z7cTon7x2uJVWtXFcFPa9y3b2EuCvor8j5bOwiNmJkV3qEx0iSUnmozBCjOF7Uwb9jyXAMCtDmoBAuy4CuG7hi8QMqXTfTniyWo7p4S8xY18THTDAlcVDOdBicnyYCnsgWVmolyMSrx/BValyuTaCO3pdyG9so77r9UJHI=  ;
X-YMail-OSG: IoUfRFEVM1mhB5Btt1s5tc5GOZMpIFpFE2lFcXXxyeJyrds6I1AOkH.MJVH5k1L7vwCdXtMthw--
Message-ID: <469471E5.9070501@yahoo.com.au>
Date: Wed, 11 Jul 2007 16:00:05 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Matthew Hawkins <darthmdh@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <200707102015.44004.kernel@kolivas.org>	 <b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>	 <20070710181419.6d1b2f7e.akpm@linux-foundation.org>	 <b21f8390707101954s3ae69db8vc30287277941cb1f@mail.gmail.com>	 <4694683B.3060705@yahoo.com.au> <2c0942db0707102247n3b6e5933i9803a2161d6c00b1@mail.gmail.com>
In-Reply-To: <2c0942db0707102247n3b6e5933i9803a2161d6c00b1@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:

> As an honest question, what's it going to take here? If I were to
> write something that watched the task stats at process exit (cool
> feature, that), and recorded the IO wait time or some such, and showed
> it was lower with a kernel with the prefetch, would *that* get us some
> forward motion on this?

Honest answer? Sure, why not. Numbers are good.

-- 
SUSE Labs, Novell Inc.
