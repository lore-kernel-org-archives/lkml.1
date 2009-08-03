Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZHCFSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZHCFSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZHCFSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:18:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:50384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbZHCFSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:18:49 -0400
Message-ID: <4A767325.20604@kernel.org>
Date: Mon, 03 Aug 2009 14:18:29 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: Add 'percpu_read_stable()' interface for cacheable
 accesses
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain> <4A76421E.3040005@kernel.org> <alpine.LFD.2.01.0908021913130.3352@localhost.localdomain> <4A7670E0.4030605@kernel.org> <4A767203.5090802@zytor.com>
In-Reply-To: <4A767203.5090802@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 05:18:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Tejun Heo wrote:
>>
>> Ingo, these patches might as well go through x86 tree.  If you think
>> that would be better, please let me know.
>>
> 
> Makes sense to me.  I'll pull them into x86/percpu.

Cool, dropping from my tree then.

Thanks.

-- 
tejun
