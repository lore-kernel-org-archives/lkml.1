Return-Path: <linux-kernel-owner+w=401wt.eu-S1767330AbXECC2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767330AbXECC2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767335AbXECC2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:28:48 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53924 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767330AbXECC2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:28:47 -0400
Message-ID: <463948D8.4000303@zytor.com>
Date: Wed, 02 May 2007 19:28:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Andi Kleen <ak@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Why ssse3?
References: <46391392.4070706@redhat.com> <200705030046.07152.ak@suse.de> <4639171A.3050004@redhat.com>
In-Reply-To: <4639171A.3050004@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> Andi Kleen wrote:
>> Nope. SSE3 != SSSE3. The additional S means Supplemential.
>>
>> It's probably because the few changes didn't justify a SSE4
> 
> OK, the problem is that the actual sse3 bit is misnamed.  According to
> Intel's docs bit 0 of ECX is "sse", the kernel uses "pni".  Too bad.

Intel has a nasty habit of renaming things after they are already
deployed in Linux.

	-hpa
