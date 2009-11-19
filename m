Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZKSTta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZKSTta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZKSTta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:49:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57228
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbZKSTt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:49:29 -0500
Date: Thu, 19 Nov 2009 11:49:46 -0800 (PST)
Message-Id: <20091119.114946.225164410.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, cooloney@kernel.org,
       tony.luck@intel.com, ralf@linux-mips.org, benh@kernel.crashing.org,
       lethal@linux-sh.org, mingo@redhat.com, travis@sgi.com
Subject: Re: [PATCH 2/6] cpumask: use tsk_cpumask() to access task_struct
 cpus_allowed.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200911191930.11038.rusty@rustcorp.com.au>
References: <200911191930.11038.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 19 Nov 2009 19:30:10 +1030

> This allows us to play with cpus_allowed.
> 
> We also take the chance to use modern cpumask_* operators on the
> lines changed.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: David S. Miller <davem@davemloft.net>
