Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZJAPbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZJAPbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZJAPbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:31:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbZJAPbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:31:05 -0400
Message-ID: <4AC4CB2A.4000908@redhat.com>
Date: Thu, 01 Oct 2009 17:30:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
References: <4AB3CDEC.5050902@zytor.com> <1253342422-13811-1-git-send-email-avi@redhat.com> <4AB8980D.5070803@redhat.com> <20090922143223.GA31702@elte.hu> <4AB8EAF2.1030204@zytor.com> <4AC4C8F2.5050708@redhat.com> <4AC4C9D5.3000902@zytor.com>
In-Reply-To: <4AC4C9D5.3000902@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 05:25 PM, H. Peter Anvin wrote:
> On 10/01/2009 08:21 AM, Avi Kivity wrote:
>    
>> Re-ping?
>>
>> If accepted, please merge just the core patch and I will carry all of
>> them in parallel.  Once tip is merged I'll drop my copy of the first patch.
>>
>>      
> I was just talking to Ingo about this... would you consider this .32 or
> .33 material at his time?  It came in awfully late for .32...
>    

While I'd prefer it to be in .32, as there's much churn in both trees, I 
guess we should follow the process and schedule it for .33.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

