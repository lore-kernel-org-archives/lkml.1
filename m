Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbZC0XRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbZC0XRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbZC0XQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:16:45 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:39115 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857AbZC0XQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:16:45 -0400
Message-ID: <49CD5E59.6030805@msgid.tls.msk.ru>
Date: Sat, 28 Mar 2009 02:16:41 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: nicolas sitbon <nicolas.sitbon@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: epoll_ctl and const correctness
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>	 <49CAA055.5060603@goop.org>	 <84a01a8b0903251437l9f9059s3c548b5d35ea47d4@mail.gmail.com>	 <84a01a8b0903270244s146ca50cr2758d36c2d9d77cd@mail.gmail.com>	 <49CD4967.2090606@msgid.tls.msk.ru>	 <84a01a8b0903271517t668c6276l7fe098d74c24b836@mail.gmail.com>	 <84a01a8b0903271530of8d43ffhf77e7ba73e309f75@mail.gmail.com>	 <49CD564E.6050101@msgid.tls.msk.ru>	 <84a01a8b0903271555i7a4fea50nd95009539aa2f94d@mail.gmail.com>	 <49CD5AC6.3020806@msgid.tls.msk.ru> <84a01a8b0903271610u17267f87u65b097ac2d755a52@mail.gmail.com>
In-Reply-To: <84a01a8b0903271610u17267f87u65b097ac2d755a52@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nicolas sitbon wrote:
> is it stupid to ask how a size can be negative? who is stupid? you're
> boring with my question, just tell me please how a size can be
> negative?

Yes I'm bored with your questions.  And am suggesting you to stop
asking me now.  That's enough.

As of size being negative - how one can read() negative number
of bytes for example?  How one can poll() waiting for a maximum
of negative number of milliseconds?

This is my last reply to you.  I have something more useful to do.

/mjt
