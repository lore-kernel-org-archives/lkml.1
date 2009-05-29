Return-Path: <linux-kernel-owner+w=401wt.eu-S1762395AbZE2P73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762395AbZE2P73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762305AbZE2P7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:59:04 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:53316 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762243AbZE2P7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:59:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=HHM7e2pgAb2DThyOdfQqlYTWolNGa0UcS4ASFxNCAnFu9wTP9SWdQpBKGuNNe9zrcM
         WWQUK+DAFld401dl/SVoCDA7UksM9bAVObt+WHibzxO2vk2tf4Y4g/UcX0OgDSsIRSUH
         aV9XORIOmH0t6XM5O9e1fw9pIAaPSOsr/gRZc=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1243609373.23657.264.camel@twins>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com>
	 <1243527919.6645.75.camel@laptop>
	 <7c86c4470905290343q2ec107f1o81a7b80232e42080@mail.gmail.com>
	 <1243609373.23657.264.camel@twins>
Date: Fri, 29 May 2009 17:59:02 +0200
Message-ID: <7c86c4470905290859k3a4d806dm15846f651b28dc95@mail.gmail.com>
Subject: Re: comments on Performance Counters for Linux (PCL)
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 5:02 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2009-05-29 at 12:43 +0200, stephane eranian wrote:
>> > I can't seem to locate the IBS stuff in the documentation currently, and
>> > I must admit I've not yet looked into it, others might have.
>> >
>> AMD BIOS and Kernel Developer's Guide (BKDG) for Family 10h, section 3.13.
>> You have the register descriptions.
>
> Gah, I only downloaded BKDG for Family 11h under the assumption it would
> include everything 10h had and then some,.. how ignorant of me :(
>
11h is the mobile series, it does not have IBS if I recall.
