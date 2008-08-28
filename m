Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbYH1QDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbYH1QDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYH1QDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:03:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:11303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYH1QDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gSD+yxWwxTvJwmbK0t9cJQbwaCHjQ4mlHxh4HlFqNd5qOpfqtWHAc1flZ+Wg+kOBjD
         ktGNf9Ic4JR0inLX9KFGdFow+YiSZxC/tVZjMXZbzAUdOebWAG6kz9ot1y11xzznNsJj
         cUOW2taXPARs3PAxcbsLxjDvwt6aLpgMGosss=
Message-ID: <c62985530808280903u435ea455uc4033209746b37d8@mail.gmail.com>
Date: Thu, 28 Aug 2008 17:03:01 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Cc: "Pekka Paalanen" <pq@iki.fi>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080828094423.GD28783@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48B1D5CA.8000607@gmail.com>
	 <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	 <20080827212130.4b8365a8@daedalus.pq.iki.fi>
	 <20080828094423.GD28783@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/28 Ingo Molnar <mingo@elte.hu>:
>
> * Pekka Paalanen <pq@iki.fi> wrote:
>
>> > Do you think I should modify something or use a way to make it
>> > better? (Added Pekka Paalanen in Cc since it concerns an idea from
>> > his mmiotrace's documentation)...
>>
>> Thanks for adding me, I've been brewing my own version of this stuff,
>> but didn't yet solve the __ftrace_printk-is-unusable issue yet. I have
>> the mmiotrace specific parts written for TRACE_PRINT, so we haven't
>> really overlapped each other's work yet.
>
> we can certainly include and test Frédéric's patch in tip/tracing/ftrace
> - i'll wait for v2 as i guess he will implement the modifications
> suggested by you?
>
>        Ingo

Ok I will send a new patch on the next days...
