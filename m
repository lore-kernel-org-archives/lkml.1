Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbYE1T0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbYE1T0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYE1T0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:26:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59171 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYE1T0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:26:41 -0400
Message-ID: <483DA034.9060408@zytor.com>
Date: Wed, 28 May 2008 11:11:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Fix up silly i1586 boot message.
References: <20080528165713.GA412@redhat.com> <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr> <20080528175941.GA4642@redhat.com>
In-Reply-To: <20080528175941.GA4642@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Wed, May 28, 2008 at 07:48:03PM +0200, Jan Engelhardt wrote:
>  > 
>  > On Wednesday 2008-05-28 18:57, Dave Jones wrote:
>  > 
>  > >Trying to boot a 64-bit kernel on a 32bit Pentium 4 gets
>  > >you an amusing message along the lines of.
>  > >"you need an x86-64, but you only have an i1586"
>  > >due to the P4 being family F.  Munge it to be 686.
>  > 
>  > What is wrong with it? If i386, 486, 586 and 686 are valid names,
>  > why should not 786 (or rather 1586... since someone thought it
>  > would be cool to jump the number^1) be?
> 
> When you find the Intel literature that refers to the '786' or the '1586',
> feel free to send a patch. In the meantime, we'll refer to it as
> the rest of the world does.

Actually, I have seen some Intel literature talking about the 786.  This 
was back when the 486 was new, and they wanted to impress how advanced 
their roadmap was.  Needless to say, it was completely bogus.

	-hpa
