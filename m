Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbYF0RyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbYF0RyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYF0Rx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:53:57 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36554 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYF0Rx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:53:57 -0400
Date: Fri, 27 Jun 2008 21:56:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, jarkao2@o2.pl,
       linux-kernel@vger.kernel.org
Subject: Re: workqueue flush_work() patches
Message-ID: <20080627175633.GA842@tv-sign.ru>
References: <486525FE.1060509@qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486525FE.1060509@qualcomm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Max Krasnyansky wrote:
> 
> I'm not sure if you guys saw my last email on this. So I'll restart the 
> thread.
> If you guys are ok with the summary I provided below I can put all 
> Oleg's patches into some git tree, test them on my boxes and resend to 
> Andrew.

I'll re-send these flush_work() patches to Andrew on Sunday,

> I was also going to go over the users of flush_queued_work() and 
> convert them to cancel_work_sync() and/or flush_work().

I think this would be very nice in any case.

but I don't think flush_work() will find a lot of users...

Oleg.

