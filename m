Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZAATZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZAATZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 14:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZAATZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 14:25:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52796 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZAATZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 14:25:17 -0500
Message-ID: <495D1889.1060507@eaglescrag.net>
Date: Thu, 01 Jan 2009 11:24:57 -0800
From: "J.H." <warthog19@eaglescrag.net>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Dave Jones <davej@redhat.com>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, ftpadmin@kernel.org
Subject: Re: [KORG] Announcement: patchwork.kernel.org
References: <fa.f9uNEYqmpJX02C68okHq8SDYyFI@ifi.uio.no>	 <495CD285.1000501@yahoo.com> <20090101183646.GA13585@redhat.com> <f73f7ab80901011043s193b5ac9s6756f9b401fc148@mail.gmail.com>
In-Reply-To: <f73f7ab80901011043s193b5ac9s6756f9b401fc148@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.1.12 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Jan 2009 11:24:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Thu, Jan 1, 2009 at 1:36 PM, Dave Jones <davej@redhat.com> wrote:
>   
>> On Thu, Jan 01, 2009 at 02:26:13PM +0000, Sitsofe Wheeler wrote:
>>  > J.H. wrote:
>>  > > If you have problems, concerns or issues please e-mail ftpadmin@kernel.org.
>>  >
>>  > I get a python error when I try and do a search:
>>  > http://patchwork.kernel.org/project/LKML/list/?q=lzma
>>
>> I've seen a number of tracebacks. They seem to be transient,
>> in that reloading any particular page eventually causes it
>> to trigger.  Reloading then makes it work again.
>>     
>
> Unfortunately it seems to have triggered on my attempt to register an
> account... and as a result I didn't get the subscription email.  Would
> it be possible for one of the admins to either confirm my subscription
> or resend the email?  I used this email address on the web form.
>
> Cheers,
> Kyle Moffett
>   
Might also have been me trying to figure out what was going on, I think 
I've got the example.com bits all worked out now (ahhh the joys of lack 
of documentation) I should have a patch for django to fill in the 
missing bit of knowledge in a bit.

That said if your still seeing tracebacks report them to ftpadmin and if 
we can't figure them out, we'll kick them over to patchwork as bug reports.

- John 'Warthog9' Hawley
