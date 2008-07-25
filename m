Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbYGYPTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbYGYPTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYGYPSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:18:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44413 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750729AbYGYPSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:18:54 -0400
Message-ID: <4889EEDB.3070501@sgi.com>
Date: Fri, 25 Jul 2008 08:18:51 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [git pull] core/percpu for v2.6.27
References: <20080714143413.GA19134@elte.hu> <alpine.LFD.1.10.0807141525000.2944@woody.linux-foundation.org> <487CC671.3000501@goop.org> <20080715210002.GA7072@elte.hu> <487D15FC.1060300@sgi.com> <20080718221730.GB31073@elte.hu>
In-Reply-To: <20080718221730.GB31073@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Ingo Molnar wrote:
>>
>> ...
>>> in hindsight core/percpu indeed looks unfinished and direction-less 
>>> without core/percpu-zerobased - but the latter is not stable yet.
>>>
>>> 	Ingo
>> Well it's very stable using gcc-4.2.4.  The earlier problems came 
>> about using gcc-4.2.0 and has yet to be determined what exactly went 
>> wrong. (And I need to install gcc-3.2 to complete the build/test QA.)
> 
> well, the crash report i gave you was with gcc-4.2.3. Or is that one 
> resolved?
> 
> 	Ingo

YES!  Patcheset to follow... ;-)

Thanks,
Mike
