Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbZK3LDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbZK3LDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZK3LDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:03:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbZK3LDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:03:33 -0500
Message-ID: <4B13A5FC.10605@redhat.com>
Date: Mon, 30 Nov 2009 13:01:16 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Gleb Natapov <gleb@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, riel@redhat.com
Subject: Re: [PATCH v2 10/12] Maintain preemptability count even for !CONFIG_PREEMPT
 kernels
References: <1258985167-29178-1-git-send-email-gleb@redhat.com>	 <1258985167-29178-11-git-send-email-gleb@redhat.com>	 <1258990455.4531.594.camel@laptop> <20091123155851.GU2999@redhat.com>	 <alpine.DEB.2.00.0911231128190.785@router.home>	 <20091124071250.GC2999@redhat.com>	 <alpine.DEB.2.00.0911240906360.14045@router.home>	 <20091130105612.GF30150@redhat.com>  <20091130105812.GG30150@redhat.com> <1259578793.20516.130.camel@laptop>
In-Reply-To: <1259578793.20516.130.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 12:59 PM, Peter Zijlstra wrote:
>> Forgot to tell. The results are average between 5 different runs.
>>      
> Would be good to also report the variance over those 5 runs, allows us
> to see if the difference is within the noise.
>    

That's the stddev column.

-- 
error compiling committee.c: too many arguments to function

