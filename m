Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbXLEQaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbXLEQaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXLEQaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:30:07 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:39909 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbXLEQaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:30:06 -0500
Message-ID: <4756D1F1.9030200@cosmosbay.com>
Date: Wed, 05 Dec 2007 17:29:37 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jie Chen <chen@jlab.org>, Simon Holm Th??gersen <odie@cs.aau.dk>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
References: <4744966C.900@jlab.org> <4744ADA9.7040905@cosmosbay.com> <4744E0DC.7050808@jlab.org> <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org> <20071204131707.GA4232@elte.hu> <4756C3D9.9030107@jlab.org> <20071205154014.GA6491@elte.hu> <4756CEEE.9050908@cosmosbay.com> <20071205162512.GA17994@elte.hu>
In-Reply-To: <20071205162512.GA17994@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 05 Dec 2007 17:29:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> $ gcc -O2 -o burner burner.c
>> $ ./burner
>> Time to perform the unit of work on one thread is 0.040328 s
>> Time to perform the unit of work on 2 threads is 0.040221 s
> 
> ok, but this actually suggests that scheduling is fine for this, 
> correct?
> 
> 	Ingo
> 
> 

Yes, But this machine runs an old kernel. I was just giving you how to run it :)

