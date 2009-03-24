Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZCXXhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZCXXhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZCXXha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:37:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54120 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbZCXXh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:37:29 -0400
Message-ID: <49C96C92.1080604@zytor.com>
Date: Tue, 24 Mar 2009 16:28:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: 2.6.30 Xen merge plan (what's in xen.git)
References: <49C915A3.3020809@goop.org> <20090324174859.GB31117@elte.hu> <49C921A8.3090200@goop.org> <49C96728.8070808@zytor.com>
In-Reply-To: <49C96728.8070808@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> I was mostly objecting to the apic patches -- I'm okay with the latest 
> version, as long as they aren't in hot code (I never got the time to 
> measure it.)
> 

Talking about performance measurements... do you have mmap-perf numbers 
(paravirt on native vs non-paravirt) for the latest -tip kernel?  I've 
lost track of the numbers after all the changes.

	-hpa

