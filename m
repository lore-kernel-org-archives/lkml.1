Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbZKYUrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbZKYUrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759805AbZKYUrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:47:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759798AbZKYUrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:47:31 -0500
Message-ID: <4B0D97EA.8040100@suse.cz>
Date: Wed, 25 Nov 2009 21:47:38 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Steppeing down as Maintainer
References: <20091120182249.GA28251@merkur.ravnborg.org> <20091120182613.GA28307@merkur.ravnborg.org> <20091125172122.46beaf17.sfr@canb.auug.org.au> <20091125172406.GA14085@merkur.ravnborg.org>
In-Reply-To: <20091125172406.GA14085@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg napsal(a):
> On Wed, Nov 25, 2009 at 05:21:22PM +1100, Stephen Rothwell wrote:
>> Hi Sam,
>>
>> On Fri, 20 Nov 2009 19:26:13 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
>>> It has been fun but the last year or more it has
>>> been a duty and a burden. So I leave it open for
>>> other to take over.
>> I, also, want to thank you very much for all your work.
>>
>> I am, however, wondering what will happen to the changes you have that are
>> currently in linux-next:
>>
>> Apparently for v2.6.32 (in kbuild-current):
>>
>> Michael Tokarev (1):
>>       kbuild: fix bzImage build for x86
>>
>> And queued for v2.6.33:
>>
>> Sam Ravnborg (14):
>>       kbuild: search arch/$ARCH/include before include/
>>       dontdiff: add generated
>>       kbuild: move bounds.h to include/generated
>>       kbuild: move asm-offsets.h to include/generated
>>       ia64: move nr-irqs.h to include/generated
>>       arm: move mach-types to include/generated
>>       sh: move machtypes.h to include/generated
>>       kbuild: drop include2/ used for O=... builds
>>       kbuild: do not check for include/asm-$ARCH
>>       kbuild: drop include/asm
>>       kbuild: move compile.h to include/generated
>>       drop explicit include of autoconf.h
>>       kbuild: move autoconf.h to include/generated
>>       kbuild: move utsrelease.h to include/generated
>>
>> I am (for the moment) still merging these from the copy I have of your
>> trees, but what to do in the longer term?
> 
> I will submit the patches like any other regular submitter to linux-kbuild
> if the upcoming Maintainers does not pick them up from the git trees.

I took your kbuild-next.git and I'm going through the other patches
posted to linux-kbuild recently. I'll push the repo once passes some
testing.

Michal
