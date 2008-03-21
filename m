Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbYCURfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbYCURfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYCURfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:35:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37518 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750880AbYCURfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:35:23 -0400
Date: Fri, 21 Mar 2008 10:33:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [11/14] vcompound: Fallbacks for order 1 stack allocations on
 IA64 and x86
In-Reply-To: <20080321083952.GA20454@elte.hu>
Message-ID: <Pine.LNX.4.64.0803211032390.18671@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061726.782068299@sgi.com>
 <20080321.002502.223136918.davem@davemloft.net> <20080321083952.GA20454@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Ingo Molnar wrote:

> another thing is that this patchset includes KERNEL_STACK_SIZE_ORDER 
> which has been NACK-ed before on x86 by several people and i'm nacking 
> this "configurable stack size" aspect of it again.

Huh? Nothing of that nature is in this patchset.
