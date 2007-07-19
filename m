Return-Path: <linux-kernel-owner+w=401wt.eu-S938636AbXGSR1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938636AbXGSR1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765861AbXGSR1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:27:15 -0400
Received: from mail.tmr.com ([64.65.253.246]:60381 "EHLO posidon.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbXGSR1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:27:15 -0400
Message-ID: <469F9EC3.8090306@tmr.com>
Date: Thu, 19 Jul 2007 13:26:27 -0400
From: Bill Davidsen <davidsen@tmr.com>
Reply-To: davidsen@posidon.tmr.com
Organization: TMR Associates, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Kent <raven@themaw.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v19
References: <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu> <1184648474.3188.33.camel@raven.themaw.net> <20070717074537.GA13539@elte.hu> <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org> <469E8821.3070700@tmr.com> <20070719143214.GA6387@elte.hu> <469F9A2E.5020107@tmr.com>
In-Reply-To: <469F9A2E.5020107@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Ingo Molnar wrote:
>> * Bill Davidsen <davidsen@tmr.com> wrote:
>>
>>>> Does the patch below help?
>
> Doesn't seem to apply against 2.6.22.1, I'm trying 2.6.22.6 as soon as 
> I recreate it.

Applied to 2.6.22-git9, building now.
