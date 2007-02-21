Return-Path: <linux-kernel-owner+w=401wt.eu-S1161335AbXBUUrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161335AbXBUUrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161336AbXBUUrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:47:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161335AbXBUUrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:47:40 -0500
Message-ID: <45DCAF37.4050301@redhat.com>
Date: Wed, 21 Feb 2007 15:44:39 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com> <20070221203928.GC17830@kroah.com>
In-Reply-To: <20070221203928.GC17830@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> What is the status of:
>>
>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-simplfy-__assign_irq_vector.patch
>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
>>
>> They fix a serious bug that causes machines to freeze up
>> or just run very slowly.
>>
>> I'd like to see these in -stable if possible.
> 
> -stable for 2.6.19 and/or .18?
> 

The bug is new in .19 and is still in .20 and .21-rc.

