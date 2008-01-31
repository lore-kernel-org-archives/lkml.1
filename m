Return-Path: <linux-kernel-owner+w=401wt.eu-S933746AbYAaUlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746AbYAaUlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 15:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbYAaUlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 15:41:35 -0500
Received: from gw.goop.org ([64.81.55.164]:48722 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800AbYAaUle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 15:41:34 -0500
Message-ID: <47A2326A.7040702@goop.org>
Date: Thu, 31 Jan 2008 12:41:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Campbell <ijc@hellion.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 04 of 11] x86: fix early_ioremap pagetable ops
References: <de52cce203cd6edeed0d.1201296193@localhost> <1201806096.20036.43.camel@cthulhu.hellion.org.uk> <20080131203713.GA24278@elte.hu>
In-Reply-To: <20080131203713.GA24278@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ian Campbell <ijc@hellion.org.uk> wrote:
>
>   
>> Some important parts of f6df72e71eba621b2f5c49b3a763116fac748f6e got 
>> dropped along the way, reintroduce them.
>>     
>
> thanks, applied. AFAICS it should only affect paravirt, not the native 
> kernel, right?
>   

Correct.

    J
