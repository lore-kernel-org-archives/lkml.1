Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYINPlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYINPlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYINPlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:41:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:59586 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYINPlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:41:06 -0400
Date: Sun, 14 Sep 2008 08:40:50 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] x86, cpa: cpa related changes to be inline with TLB
 Application note
Message-ID: <20080914084050.07e036d3@linux.intel.com>
In-Reply-To: <20080911203048.929515000@linux-os.sc.intel.com>
References: <20080911203048.929515000@linux-os.sc.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 13:30:48 -0700
Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Following patches fixes this behavior.
> 
> [1] http://developer.intel.com/design/processor/applnots/317080.pdf
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
