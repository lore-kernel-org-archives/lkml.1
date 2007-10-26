Return-Path: <linux-kernel-owner+w=401wt.eu-S1763351AbXJZSAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763351AbXJZSAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbXJZSAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:00:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37659 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbXJZSAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:00:31 -0400
Message-ID: <47222AFA.9030902@zytor.com>
Date: Fri, 26 Oct 2007 10:59:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Fix boot protocol KEEP_SEGMENTS check.
References: <m1r6jh3hun.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6jh3hun.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Both x86 and x86_64 support the same boot protocol so we need
> to implement the KEEP_SEGMENTS on x86_64 as well.  It isn't
> just paravirt bootloaders that could use this functionality.
> 

Out of curiousity, what other users do you see?

	-hpa
