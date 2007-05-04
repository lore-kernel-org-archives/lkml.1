Return-Path: <linux-kernel-owner+w=401wt.eu-S1031709AbXEDVG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031709AbXEDVG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031707AbXEDVG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:06:58 -0400
Received: from www.osadl.org ([213.239.205.134]:60148 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031709AbXEDVG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:06:57 -0400
Subject: Re: [patch] export hrtimer_forward
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stas Sergeev <stsp@aknet.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070503165800.5b7cd3fd.akpm@linux-foundation.org>
References: <463A2296.7000804@aknet.ru> <1178218674.24217.14.camel@twins>
	 <463A338A.2010909@aknet.ru>
	 <20070503165800.5b7cd3fd.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 04 May 2007 23:08:36 +0200
Message-Id: <1178312916.4471.0.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 16:58 -0700, Andrew Morton wrote:
> It was probably an oversight - generally we take the position that all the
> formal interface of a subsystem is exported to modules rather than a
> piecemeal whichever-bits-kernel.org-happens-to-use-today approach.
> 
> Thomas, is hrtimer_forward() considered part of the hrtimer public API? 
> And are you OK with the patch?

Yes to both.

	tglx


