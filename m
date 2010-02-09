Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0BIXMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 18:12:46 -0500
Received: from mail.tmr.com ([64.65.253.246]:38299 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab0BIXMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 18:12:45 -0500
Message-ID: <4B71EBD8.8070406@tmr.com>
Date: Tue, 09 Feb 2010 18:12:24 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc6 crashes on resume
References: <4B70982F.8090208@roadwarrior3.tmr.com> <201002090009.50118.rjw@sisk.pl>
In-Reply-To: <201002090009.50118.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 09 February 2010, Bill Davidsen wrote:
>> Pretty simple to reproduce, boot, suspend, press shift
>>
>> Acer Aspire 1681, Celeron, 2.6.33-rc6. Trace and config attached.
> 
> I guess 2.6.32 didn't crash?
> 
Wasn't testing. 2.6.32.5 didn't crash, later Fedora kernels kill the touchpad, I 
can dig up the old bugzilla if you can't find it.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
