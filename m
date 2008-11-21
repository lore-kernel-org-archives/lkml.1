Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYKUMJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYKUMJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbYKUMJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:09:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47429
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753425AbYKUMJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:09:09 -0500
Date: Fri, 21 Nov 2008 04:09:09 -0800 (PST)
Message-Id: <20081121.040909.261087309.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] cpumask: sparc: Introduce cpumask_of_{node,pcibus}
 to replace {node,pcibus}_to_cpumask
From: David Miller <davem@davemloft.net>
In-Reply-To: <200811212206.04337.rusty@rustcorp.com.au>
References: <200811212206.04337.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 22:06:04 +1030

> 
> Impact: New APIs
> 
> The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
> return a pointer to a struct cpumask.  Part of removing cpumasks from
> the stack.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: David S. Miller <davem@davemloft.net>
