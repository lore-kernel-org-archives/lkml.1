Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbYCYCfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbYCYCfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbYCYCci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:32:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56446 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518AbYCYCcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:32:36 -0400
Message-ID: <47E86442.8030708@garzik.org>
Date: Mon, 24 Mar 2008 22:32:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, kurt@roeckx.be,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc6] sata_promise: fix hardreset hotplug events,
 take 2
References: <200803221421.m2MEL1oY021558@harpo.it.uu.se> <18406.38445.717175.664615@harpo.it.uu.se> <47E70FB4.4010802@gmail.com>
In-Reply-To: <47E70FB4.4010802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Acked-by: Tejun Heo <htejun@gmail.com>
> 
> Jeff, do you want to merge this first?  If so, I'll update the
> prefer-hardreset and cleanup-sht-ops patchsets; otherwise, I'll massage
> this patch a bit so that it fits on top of those two patchsets.


I just merged it into #upstream-fixes (answering your question)...  what 
is your preferred method of sync'ing at this point?

	Jeff


