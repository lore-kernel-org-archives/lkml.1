Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZIOICY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZIOICY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZIOICV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:02:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZIOICU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:02:20 -0400
Message-ID: <4AAF4A9E.3050101@redhat.com>
Date: Tue, 15 Sep 2009 16:04:46 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Patch] kbuild: fix a compile warning
References: <20090515075229.11346.6710.sendpatchset@localhost.localdomain>	 <20090528004100.3716e00d.akpm@linux-foundation.org>	 <4A21EA8E.6060507@redhat.com> <94a0d4530909130705o6886d496o670d1b978a9fc75f@mail.gmail.com>
In-Reply-To: <94a0d4530909130705o6886d496o670d1b978a9fc75f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Contreras wrote:
> On Sun, May 31, 2009 at 5:25 AM, Amerigo Wang <amwang@redhat.com> wrote:
>> Andrew Morton wrote:
>>> On Fri, 15 May 2009 03:51:18 -0400 Amerigo Wang <amwang@redhat.com> wrote:
>>>
>>>
>>>> I got this warning:
>>>>
>>> With which gcc version?
>>>
>> gcc version 4.4.0 (GCC)
> 
> I'm also getting this warning on 4.4.1. Can we merge this patch?
> 

I believe we already merged this patch in
commit d067aa7.

Can you try the latest linus git tree?

Thanks.
