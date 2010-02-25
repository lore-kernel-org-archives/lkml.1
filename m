Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab0BYLLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:11:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:47826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955Ab0BYLLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:11:20 -0500
Subject: Re: [PATCH] early_res: add free_early_partial
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <4B85E245.5030001@kernel.org>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
	 <1265793639-15071-17-git-send-email-yinghai@kernel.org>
	 <20100215010833.15f9e09a.sfr@canb.auug.org.au>
	 <4B7B4378.1070206@kernel.org> <1267052387.12790.10.camel@laptop>
	 <4B85B65E.503@kernel.org> <4B85B724.9050304@kernel.org>
	 <4B85DB79.4010708@kernel.org>  <4B85E245.5030001@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 12:10:25 +0100
Message-ID: <1267096225.12790.135.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 18:36 -0800, Yinghai Lu wrote:
> 
> 
> to free partial for pcpu_setup...
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
This seems to cure my panic..

Tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

