Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbXF2Mpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbXF2Mpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbXF2Mp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:45:26 -0400
Received: from gw.goop.org ([64.81.55.164]:39775 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbXF2MpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:45:25 -0400
Message-ID: <4684FEAE.2010009@goop.org>
Date: Fri, 29 Jun 2007 08:44:30 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Chuck Ebbert <cebbert@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: i386 boot fail, EIP in __change_page_attr:166
References: <a8e1da0706242043w56ed75f0h208ee9646ae7b7d0@mail.gmail.com>	 <467FF37D.5000304@redhat.com>	 <a8e1da0706251811k636b7b8dmc21e5bfc26b09e06@mail.gmail.com>	 <46814D85.5070406@redhat.com>	 <a8e1da0706261815sc25dd1t6bf0dc809923e859@mail.gmail.com>	 <468273FC.5080905@goop.org>	 <a8e1da0706290200x156a80ci2365646f67b279e9@mail.gmail.com> <a8e1da0706290204r41f433e5s8a03c070e7d28655@mail.gmail.com>
In-Reply-To: <a8e1da0706290204r41f433e5s8a03c070e7d28655@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
>> The diffrences is net520c item.
>>
> sorry it is netsc520, I will post the patch after a while.

I read your other mail out of order, and I'd forgotten about this oops.  
But still, the fix you posted doesn't look quite right.  How big is the 
netsc520 ioremap?

    J
