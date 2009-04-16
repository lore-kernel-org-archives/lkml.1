Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZDPEfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZDPEfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 00:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZDPEff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 00:35:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZDPEfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 00:35:34 -0400
Message-ID: <49E6B51A.5030501@zytor.com>
Date: Wed, 15 Apr 2009 21:33:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
References: <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu> <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain> <20090415224017.GA18764@elte.hu> <alpine.LFD.2.00.0904151607010.4042@localhost.localdomain> <20090416000841.GA18185@elte.hu> <alpine.LFD.2.00.0904151717040.4042@localhost.localdomain> <alpine.LFD.2.00.0904151736140.4042@localhost.localdomain> <20090416005025.GA2779@elte.hu>
In-Reply-To: <20090416005025.GA2779@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>
>> At least then it wouldn't break up the narrative, and it would 
>> kind of fit with all the other "tagged" lines.
> 
> Yeah, that makes sense.
> 

Actually, there is one good thing about this.  One of the things we've
found useful is to have the maintainer add or edit Impact: lines.
Putting them with the tags would make it more clear who did the impact
assessment.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

