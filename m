Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbZAPNIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbZAPNIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZAPNIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:08:06 -0500
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:64246 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbZAPNIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:08:05 -0500
Message-ID: <497086AC.80201@Calva.COM>
Date: Fri, 16 Jan 2009 14:07:56 +0100
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: A patch to arch/i386/kernel/irq.c to help get backtraces of	(near)
 stack overflow situations
References: <49707BA9.1040102@Calva.COM> <20090116123844.GB5421@elte.hu> <497081F7.5070007@Calva.COM> <20090116125731.GG5421@elte.hu>
In-Reply-To: <20090116125731.GG5421@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * John Hughes <john@Calva.COM> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>> in recent kernel's there's an automatic maximum-stack-footprint tracer  
>>> plugin available.
>>>       
>> Lovely.  Maybe one day I'll be able to use a recent kernel.  :-)
>>     
>
> Curious, is that inability of using recent kernls our fault or your fault?
> :)
>   
Oh, mine, all mine.  Just can't find the time.  :-)

(Well, I could blame you buggers for moving too fast, but I doubt that 
would be appreciated :-)).

