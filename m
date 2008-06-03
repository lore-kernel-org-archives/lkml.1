Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbYFCCVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbYFCCVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbYFCCVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 22:21:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50693 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbYFCCVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 22:21:08 -0400
Date: Mon, 2 Jun 2008 19:20:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Pavel Machek <pavel@ucw.cz>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080602192048.39c86b2e@infradead.org>
In-Reply-To: <20080602175400.GN5504@dirshya.in.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
	<20080526085000.33787eac@infradead.org>
	<483AF25B.6090806@linux.vnet.ibm.com>
	<20080526110040.5ddc4656@infradead.org>
	<483B0348.2000204@linux.vnet.ibm.com>
	<20080526115108.6a19e2c0@infradead.org>
	<483C059B.9040301@linux.vnet.ibm.com>
	<20080531212709.GA6757@ucw.cz>
	<20080602175400.GN5504@dirshya.in.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 23:24:00 +0530
Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> 
> Lets start adding parameters in steps to make the scaled statistics
> accurate.  We want to start with cpu and see if we can provide
> a reasonable solution.

sadly your patches don't even achieve that ;-(
At least not in terms of CPU capacity etc.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
