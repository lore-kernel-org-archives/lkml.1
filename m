Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbXJYMMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbXJYMMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 08:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXJYMMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 08:12:39 -0400
Received: from ro-out-1112.google.com ([72.14.202.183]:24057 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXJYMMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 08:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YgVVcVIA888I0/y9w8acpQJE9tfO65EfpukDpkb4gBk686VoiNkTlv9AjmpoCdj3Lscdi3J6nvSMB1zaiiE6UfB0eTmNrnpzC9VchmFAy/Mi4dBBHjrhNceRpct9h3myJN3v8bEx8TjRJ308UPJJpZ2VF6qDXAy2V6sNvIlP2p8=
Date: Thu, 25 Oct 2007 20:08:08 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86 patch] Fix UML ubd_kern.c build error
Message-ID: <20071025120807.GD2459@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071025115020.30481.60740.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025115020.30481.60740.sendpatchset@balbir-laptop>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 05:20:20PM +0530, Balbir Singh wrote:
>
>
>Fix UML build error, include linux/scatterlist.h in arch/um/drivers/ubd_kern.c,
>to resolve the definition of sg_page()
>
>Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

This is already fixed by me[1]. ;)

[1] http://lkml.org/lkml/2007/10/24/86

Regards.

-- 
May the Source Be With You.
