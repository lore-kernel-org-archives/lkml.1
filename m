Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbZASJge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbZASJge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbZASJgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:36:11 -0500
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:46689 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbZASJgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:36:09 -0500
Message-ID: <4974497B.7060302@Calva.COM>
Date: Mon, 19 Jan 2009 10:35:55 +0100
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: A patch to arch/i386/kernel/irq.c to help get backtraces of (near)
 stack overflow situations
References: <49707BA9.1040102@Calva.COM> <87k58tdzyg.fsf@basil.nowhere.org>
In-Reply-To: <87k58tdzyg.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> John Hughes <john@Calva.COM> writes:
>
>   
>> Here's a little patch to irq.c to make stack overflow dumps use a
>> separate stack.
>>     
>
> This has been fixed last year in mainline with 
> 04b361abfdc522239e3a071f3afdebf5787d9f03
>   
Ah, thanks, neater than my fix.
> Morale: If you use ancient kernels you miss a lot of bugfixes.
>   
Hey, don't you be ruining my morale, it's low enough already.  :-)

