Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbXLDQrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbXLDQrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXLDQrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:47:43 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:36847 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXLDQrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:47:42 -0500
Message-ID: <475584A4.6080800@cateee.net>
Date: Tue, 04 Dec 2007 17:47:32 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9246] On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel
 paging request at virtual address 3d15b925
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <471F8CAE.8000906@cateee.net> <20071204100832.GA11031@elte.hu>
In-Reply-To: <20071204100832.GA11031@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hi,
> 
> * Giacomo Catenazzi <cate@cateee.net> wrote:
> 
>> On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel paging request at 
>> virtual address 3d15b925
>>
>> In last git, I see the following BUGs in various programs.  It seems 
>> reproducible, but sometime I've hard lookup on poweroff.
> 
> do you still get this with more recent kernels? We had a number of fixes 
> for memory corruptors since -rc1 - perhaps one of them took care of your 
> problem as well.

No, the problem was solved few days after the report.

Thanks,
	cate

