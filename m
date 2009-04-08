Return-Path: <linux-kernel-owner+w=401wt.eu-S1751745AbZDHBQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbZDHBQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 21:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZDHBQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 21:16:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:15788 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbZDHBQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 21:16:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ey5jJm6fGqntAwkEABT/dhKMimsYIaeUpUhTlx628QQmS/BVhmbGvV9ObZy9zs8ycn
         czEDLUaUyVYAFZUhkVo8ZTWe+oXZzhpWE2buoNSJWrrKXOM2a+3w4Hj/woeOxuh8z6w6
         WAHH9R635OHbTPPEn0OGbtZWcz1IiFERjk4Do=
MIME-Version: 1.0
In-Reply-To: <9b1675090904071352x513510ecm8b2574859b088275@mail.gmail.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain>
	 <49DB7C77.1000702@s5r6.in-berlin.de>
	 <9b1675090904070944m798ed608i1d9194ebd1ed3961@mail.gmail.com>
	 <49DB8909.3000905@s5r6.in-berlin.de>
	 <9b1675090904071122k6a53295fwfffc336011edee8e@mail.gmail.com>
	 <49DBA821.1070408@s5r6.in-berlin.de>
	 <9b1675090904071352x513510ecm8b2574859b088275@mail.gmail.com>
Date: Tue, 7 Apr 2009 19:16:08 -0600
Message-ID: <9b1675090904071816k59080f1fn39737767db4dc0c@mail.gmail.com>
Subject: Re: 2.6.29 on MacBook 2,1 fails to reboot (was Re: 2.6.29-git13: 
	Reported regressions from 2.6.28)
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 7, 2009 at 2:52 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> On Tue, Apr 7, 2009 at 1:23 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>>
>> But more importantly, is this init scripts related bug really what's
>> happening at your system?  Or do you actually experience an entirely
>> different bug?
>
> It could be.  I will try it out when I get home from work, and get
> back to you.  That would be cool if it was a simple init script
> problem.  Cause then I don't have to do anymore git bisects. ;)

Yes, the order is what causes this, you can close the bug.

Sorry for wasting everyone's time.  I thought it was a kernel bug
because I had not needed to update my gentoo system to make it happen.

Thanks.
