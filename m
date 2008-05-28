Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYE1Tbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYE1Tbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYE1Tbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:31:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43401 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbYE1Tbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:31:39 -0400
Message-ID: <483DB2D5.8050502@zytor.com>
Date: Wed, 28 May 2008 12:30:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Jan Engelhardt <jengelh@medozas.de>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Fix up silly i1586 boot message.
References: <20080528165713.GA412@redhat.com> <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.55.0805281850540.29522@cliff.in.clinika.pl> <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.55.0805281916480.29522@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0805281916480.29522@cliff.in.clinika.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Wed, 28 May 2008, Jan Engelhardt wrote:
> 
>> 801586 or 81586, that is the question. Or 80F86.
> 
>  Hmm, 801586 should be fine as with Intel 80 used to stand for
> microprocessors and 81586 would be confusing as I think 81 was used for
> RAM devices (82 stood for peripherals, BTW).  My vote is for 80F86 though,
> with "F" standing for "fast" as in the 74 TTL series. ;)
> 

uname reports i686 on these chips.  The rest is ridiculous.

	-hpa
