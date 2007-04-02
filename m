Return-Path: <linux-kernel-owner+w=401wt.eu-S933264AbXDBQJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264AbXDBQJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXDBQJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:09:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933264AbXDBQJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:09:16 -0400
Message-ID: <46112AAA.9050207@redhat.com>
Date: Mon, 02 Apr 2007 12:09:14 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ashish Singhai <hybrid.rules@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PCI: iomem bigger than 4GB
References: <20070401155132.34029.qmail@web51601.mail.re2.yahoo.com>
In-Reply-To: <20070401155132.34029.qmail@web51601.mail.re2.yahoo.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ashish Singhai wrote:
> Hello,
> 
> Please refer to Andrew' post on this thread on PCI
> subsystem assigning prefetchable memory bigger than
> 4GB:
> 
> http://lkml.org/lkml/2006/11/24/160
> 
> This patch is not included in 2.6.20.1 or earlier --
> it would be helpful if we could have this patch
> considered. I have tried it in a simulated environment
> and it works.

What bug does it fix?


