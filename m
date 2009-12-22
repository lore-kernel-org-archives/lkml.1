Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZLVSzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZLVSzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 13:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZLVSzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 13:55:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbZLVSzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 13:55:09 -0500
Message-ID: <4B3115C1.4070303@redhat.com>
Date: Tue, 22 Dec 2009 20:53:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> <4B3103B4.4070708@gmail.com>
In-Reply-To: <4B3103B4.4070708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2009 07:36 PM, Gregory Haskins wrote:
>
>> Gregory, it would be nice if you worked _much_ harder with the KVM folks
>> before giving up.
>>      
> I think the 5+ months that I politely tried to convince the KVM folks
> that this was a good idea was pretty generous of my employer.  The KVM
> maintainers have ultimately made it clear they are not interested in
> directly supporting this concept (which is their prerogative), but are
> perhaps willing to support the peripheral logic needed to allow it to
> easily interface with KVM.  I can accept that, and thus AlacrityVM was born.
>    

Review pointed out locking issues with xinterface which I have not seen 
addressed.  I asked why the irqfd/ioeventfd mechanisms are insufficient, 
and you did not reply.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

