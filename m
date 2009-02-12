Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbZBLXpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbZBLXpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbZBLXpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:45:40 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:29610 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZBLXpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:45:39 -0500
X-BigFish: VPS-45(zz1432R98dR936eQ1805M936fM9371P103dKzzzzz2fh6bh61h38m)
X-EF: str=0001.0A09020A.4994B4A2.0127,ss=3,fgs=0
X-Spam-TCS-SCL: 0:0
Message-ID: <4994B466.5050102@am.sony.com>
Date: Thu, 12 Feb 2009 15:44:38 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7][RFC] function graph tracer port to PowerPC
References: <20090212011051.265346435@goodmis.org> <4994B1A3.8080502@am.sony.com> <alpine.DEB.1.10.0902121840590.15469@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0902121840590.15469@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2009 23:44:39.0008 (UTC) FILETIME=[DE764600:01C98D6B]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2009 03:41 PM, Steven Rostedt wrote:
> On Thu, 12 Feb 2009, Geoff Levand wrote:
> 
>> On 02/11/2009 05:10 PM, Steven Rostedt wrote:
>> > This is the port to PowerPC of the function graph tracer that was written
>> > by Frederic Weisbecker for the x86 architecture.  It is broken up
>> > into a series of logical steps.
>> 
>> I added these to my ps3-linux.git tree.  Very casual testing shows
>> they seem to work OK.
>> 
>> 
>> Tested-by: Geoff Levand <geoffrey.levand@am.sony.com>  Working OK on PS3.
> 
> Thanks!
> 
> Is the ps3 64 or 32 bit? I'll put your tested by on the appropriate 
> patches.

It uses the Cell processor, which is 64 bit.

-Geoff

