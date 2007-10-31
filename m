Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXJaQT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXJaQT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbXJaQTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:19:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48279 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbXJaQTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:19:20 -0400
Subject: Re: [PATCH] lockdep: fix mismatched lockdep_depth/curr_chain_hash
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Greg KH <greg@kroah.com>, Chuck Ebbert <cebbert@redhat.com>,
       stable <stable@kernel.org>, mingo@elte.hu,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071031154313.15685.72379.stgit@ghaskins-t60p.haskins.net>
References: <20071031154313.15685.72379.stgit@ghaskins-t60p.haskins.net>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 17:19:00 +0100
Message-Id: <1193847540.27652.234.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-31 at 11:44 -0400, Gregory Haskins wrote:
> Hi Greg,
>    Here is the backported version of the patch.  I applied it on top of
>    2.6.22.10.  Let me know if you have any issues.
> 
> -Greg

Thanks Gregory!



