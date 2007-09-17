Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbXIQRg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbXIQRg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXIQRgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:36:21 -0400
Received: from il.qumranet.com ([82.166.9.18]:42008 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbXIQRgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:36:20 -0400
Message-ID: <46EEBAFF.2040505@qumranet.com>
Date: Mon, 17 Sep 2007 19:35:59 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 045/104] KVM: Fix defined but not used warning
 in drivers/kvm/vmx.c
References: <11900179463203-git-send-email-avi@qumranet.com>	<11900179473956-git-send-email-avi@qumranet.com> <20070917.092708.112622378.davem@davemloft.net>
In-Reply-To: <20070917.092708.112622378.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Mon, 17 Sep 2007 19:35:59 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> You've got to be kidding me.
>
> 104 patches is way over the top, post them in smaller chunks
> please instead of killing vger.kernel.org as it has to crunch
> out every single one of these 104 patches to several thousand
> recipients.
>
>   

I can understand the load on the humans (and will split into several
rounds in the future), but why is vger.kernel.org so badly affected? 
Shouldn't the mta throttle itself instead of dying?

Just curious.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

