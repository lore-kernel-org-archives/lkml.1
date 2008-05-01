Return-Path: <linux-kernel-owner+w=401wt.eu-S1762522AbYEAAke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762522AbYEAAke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYEAAkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:40:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:22075 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYEAAkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=eGjDfQ7/4wGOB2DkWshPkQlzSwaxRqBXzmnnM2HYv4vcA5nBnmafmmos3w1fOIZTk30eM8cvxeMS2V+XqoZsqDnlVMjRtnUyogm37ceyPyumNmdFMDa7bKg+kPPzuN9pnPDvOXTIM4Ze7Iyjjyf8T6HCFWOODMHZ5bqyBuseadU=
Message-ID: <48191170.60205@gmail.com>
Date: Thu, 01 May 2008 09:40:16 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Greg KH <greg@kroah.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Emilian.Medve@Freescale.com, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] [POWERPC] devres: Add devm_ioremap_flags()
References: <Pine.LNX.4.64.0804301059430.22937@blarg.am.freescale.net>
In-Reply-To: <Pine.LNX.4.64.0804301059430.22937@blarg.am.freescale.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> From: Emil Medve <Emilian.Medve@Freescale.com>
> 
> We provide an ioremap_flags so provide a coresphonding devm_ioremap_flags.
> 
> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
