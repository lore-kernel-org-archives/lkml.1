Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbZDQIdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbZDQIdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZDQIdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:33:45 -0400
Received: from relay.atmel.no ([80.232.32.139]:51902 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbZDQIdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:33:44 -0400
Date: Fri, 17 Apr 2009 10:33:17 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>, jgarzik@pobox.com,
       netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] macb: Kconfig net device compat fixup
Message-ID: <20090417103317.568f5e85@hskinnemoen-d830>
In-Reply-To: <20090417094602.51ec1b21@hskinnemoen-d830>
References: <1239953045.2837.58.camel@linux-51e8.site>
	<20090417094602.51ec1b21@hskinnemoen-d830>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> > Of course really macb should be updated but in the mean time, this at
> > least avoid randconfig problems.  
> 
> It doesn't look all that difficult. Could you try the below instead?

Better yet, try this one:

http://patchwork.ozlabs.org/patch/25861/

which is the one that has been applied to -next.

Haavard
