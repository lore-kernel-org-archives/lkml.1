Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZJSNlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZJSNlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 09:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbZJSNlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 09:41:05 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:44631 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbZJSNlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 09:41:03 -0400
Message-ID: <4ADC6C76.3040908@monstr.eu>
Date: Mon, 19 Oct 2009 15:41:10 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, mingo@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       rostedt@goodmis.org, hpa@zytor.com, cebbert@redhat.com,
       tony.luck@intel.com
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <4AD6EA57.6020105@kernel.org> <4AD80CD6.7030204@monstr.eu> <4ADA845E.4080109@kernel.org>
In-Reply-To: <4ADA845E.4080109@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Sorry about the delay.

no worries about.

> 
> Michal Simek wrote:
>> where is git repo with that patches?
> 
> The patches are available in the following git tree.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git unified-symbols
> 
> and the original thread at
> 
>  http://thread.gmane.org/gmane.linux.kernel/902383

I compiled it there is no problem.
I hope you will add these patches through linux-next which I test every day.

Thanks,
Michal


> 
> Thanks.
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
