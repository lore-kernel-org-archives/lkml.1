Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbYF0Qcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbYF0Qcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYF0Qci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:32:38 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:65072 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYF0Qch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:32:37 -0400
Message-ID: <4865160C.2040403@nortel.com>
Date: Fri, 27 Jun 2008 10:32:12 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] x86: nmi_watchdog - documentation fix
References: <20080627154340.GC18957@cvg> <Pine.LNX.4.55.0806271652020.8868@cliff.in.clinika.pl> <20080627165937.2f1fb661@lxorguk.ukuu.org.uk>
In-Reply-To: <20080627165937.2f1fb661@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 16:32:16.0764 (UTC) FILETIME=[5CAB7BC0:01C8D873]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 27 Jun 2008 16:54:19 +0100 (BST)
> "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
> 
> 
>>On Fri, 27 Jun 2008, Cyrill Gorcunov wrote:
>>
>>
>>>+NOTE: Prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
>>>+on x86 SMP boxes.
>>
>> While you are at it: s/is/was/.
> 
> 
> Erm - why ??
> 
> It is still true today that kernels < 2.4.2-ac8 have the NMI oopser
> enabled.

To my ear the phrase as written implies past tense for the author/reader 
(i.e. "at points in time prior to the release of 2.4.2-ac18"), and thus 
grates against "is".

The following sounds better to me: "In kernels prior to 2.4.2-ac18 the 
NMI-oopser is enabled..."  In this context the phrase itself is in the 
present, but we point to past kernels.

Chris
