Return-Path: <linux-kernel-owner+w=401wt.eu-S935935AbZFOWZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935935AbZFOWZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760226AbZFOWZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:25:35 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:1386 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbZFOWZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=o/yOFMG7L9hSSYwjc14YM03DoZkRz2Ae0BbUxpWH/z+M0lEWrh3KdXc4a3QD+HuFHT
         hWvbTexC9MIQOTkGUJXx/ob5fXQrAxHTCoV4Dm5hDfJhn5WjOZ0wZAt88/jAcDCWf2w0
         JL3xfgOFUsb1h6mr/Jxtw9JyMtkKVTe3XBOEQ=
MIME-Version: 1.0
In-Reply-To: <20090615162150.GC6842@huya.quicinc.com>
References: <20090611140624.GS795@n2100.arm.linux.org.uk>
	 <4A3175AC.9070100@bluewatersys.com>
	 <alpine.LFD.2.00.0906112105220.31536@xanadu.home>
	 <4A31AECA.6070303@bluewatersys.com>
	 <alpine.LFD.2.00.0906112138090.31536@xanadu.home>
	 <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com>
	 <20090612103521.GD18682@elf.ucw.cz>
	 <a55d774e0906120344p57226dd4ve526f274a2bf7c8e@mail.gmail.com>
	 <a55d774e0906130005v5a35aa60ybabde470ff44cf77@mail.gmail.com>
	 <20090615162150.GC6842@huya.quicinc.com>
Date: Tue, 16 Jun 2009 08:25:35 +1000
X-Google-Sender-Auth: 42f534900f2793ad
Message-ID: <17b28da20906151525q1d8f10daj734faacf5dafda12@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Ben Leslie <benno@benno.id.au>
To: Brian Swetland <swetland@google.com>, Pavel Machek <pavel@ucw.cz>,
       Nicolas Pitre <nico@cam.org>, Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 2:21 AM, <davidb@quicinc.com> wrote:
> On Sat, Jun 13, 2009 at 12:05:50AM -0700, Brian Swetland wrote:
>
>> I suspect it wouldn't be hard to just get something like a full
>> arm-debian distribution booting, but that's not something I've ever
>> tried.
>
> We built a userspace around ptxdist.  We're still in the process
> of releasing it, but part of it is at
> <https://www.codeaurora.org/gitweb/quic/le/>
>
> The Android busybox
> <http://benno.id.au/blog/2007/11/14/android-busybox> mostly
> works.  The poster doesn't seem to provide source, even though
> busybox requires modification to build for Android (although not
> much).

I didn't need to change anything; I just compiled busybox; No changes
required. (Note: It is a static binary that includes glibc).

Cheers,

Benno
