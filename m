Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbXEWCvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbXEWCvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 22:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbXEWCvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 22:51:01 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20536 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471AbXEWCvA (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 22:51:00 -0400
Date: Tue, 22 May 2007 19:56:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: LKML <Linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2.6.21-rt6]
Message-Id: <20070522195624.f67c6601.randy.dunlap@oracle.com>
In-Reply-To: <1179885687.25500.92.camel@sx.thebigcorporation.com>
References: <1179885687.25500.92.camel@sx.thebigcorporation.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 19:01:27 -0700 Sven-Thorsten Dietrich wrote:

> Restore the declaration of rcu_batches_completed_bh
> 
> It is needed to compile with Classic RCU 

Please use a descriptive (and different) Subject: for each patch.
Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
