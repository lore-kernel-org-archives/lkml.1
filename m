Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbXKNQZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbXKNQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXKNQZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:25:20 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40965 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbXKNQZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:25:19 -0500
Date: Wed, 14 Nov 2007 22:07:49 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Grant Wilson <grant.wilson@zen.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc1-gb4f5550 oops
Message-ID: <20071114163749.GH3359@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071114151708.GA12355@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114151708.GA12355@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 06:17:08PM +0300, Oleg Nesterov wrote:
> Suppose that old user_struct/task_group is freed/reused, and the task does

Shouldn't this old user actually be the root user_struct?

-- 
Regards,
vatsa
