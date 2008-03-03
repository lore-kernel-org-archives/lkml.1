Return-Path: <linux-kernel-owner+w=401wt.eu-S1762374AbYCCVMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374AbYCCVMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYCCVMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:12:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbYCCVMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:12:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
X-Fcc: ~/Mail/linus
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, i387: fix ptrace leakage using init_fpu()
In-Reply-To: Suresh Siddha's message of  Monday, 3 March 2008 13:01:08 -0800 <20080303210108.GA28006@linux-os.sc.intel.com>
References: <20080303210108.GA28006@linux-os.sc.intel.com>
X-Shopping-List: (1) Hesitant dog sofas
   (2) Polygynous sandwiches
   (3) Hard-core minions
   (4) Gripping logs
Message-Id: <20080303211237.1D5402700FB@magilla.localdomain>
Date: Mon,  3 Mar 2008 13:12:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a good fix to me.

Thanks,
Roland
