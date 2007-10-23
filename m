Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbXJWOU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbXJWOU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXJWOUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:20:50 -0400
Received: from il.qumranet.com ([82.166.9.18]:34276 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbXJWOUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:20:49 -0400
Message-ID: <471E033E.20701@qumranet.com>
Date: Tue, 23 Oct 2007 16:20:46 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Bart Trojanowski <bart@jukie.net>
CC: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [BUG] 2.6.23.1 host freezes when running kvm
References: <20071019202019.GW3962@jukie.net> <20071020000240.GX3962@jukie.net>	<20071020154445.GA5254@jukie.net> <471B366B.7040706@qumranet.com>	<20071022132820.GA3962@jukie.net> <471CA88B.7000706@qumranet.com> <20071023135410.GF3962@jukie.net>
In-Reply-To: <20071023135410.GF3962@jukie.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 23 Oct 2007 16:20:46 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Trojanowski wrote:
> * Avi Kivity <avi@qumranet.com> [071022 09:42]:
>   
>> I'm not sure that's useful -- very little changed after 2.6.23-rc1 (10 
>> patches).
>>
>> There were 92 kvm patches in 2.6.23, so a bisect should take about a 
>> week worst case.
>>     
>
> I'll get started tonight.
>
>   

Thanks, that will be most helpful.  If userspace won't compile against
some intermediate version, let me know the commit hash and I'll add a fixup.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

