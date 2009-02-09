Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZBIMTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZBIMTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbZBIMSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:18:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46448 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbZBIMSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:18:54 -0500
Message-ID: <49901F1E.80106@redhat.com>
Date: Mon, 09 Feb 2009 14:18:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linus 2.6.29-rc4
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> <20090208172111.6941cd3e@infradead.org> <20090209082816.GA14808@elte.hu>
In-Reply-To: <20090209082816.GA14808@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> 8 times		apic_mmio_read			http://www.kerneloops.org/searchweek.php?search=apic_mmio_read
>>     
>
> The last one seems KVM related.
>   

Yes, it is.  Are there any human reports rather than kerneloops reports?

-- 
error compiling committee.c: too many arguments to function

