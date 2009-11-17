Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZKQUhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZKQUhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZKQUhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:37:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbZKQUhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:37:18 -0500
Message-ID: <4B030799.9020402@zytor.com>
Date: Tue, 17 Nov 2009 12:29:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: Limit the number of processor bootup messages
References: <20091117191752.164451000@alcatraz.americas.sgi.com>	 <20091117191757.651569000@alcatraz.americas.sgi.com> <86802c440911171210x4780c08cg3b3260afd5d2bc5d@mail.gmail.com>
In-Reply-To: <86802c440911171210x4780c08cg3b3260afd5d2bc5d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 12:10 PM, Yinghai Lu wrote:
>>
>> The following lines have been removed:
>>
>>        CPU: Physical Processor ID:
>>        CPU: Processor Core ID:
>>        CPU %d/0x%x -> Node %d
> 
> please don't.
> 

Why not?

Or, more formally: please state the rationale for keeping them.
	
	-hpa

