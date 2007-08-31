Return-Path: <linux-kernel-owner+w=401wt.eu-S1763182AbXHaBRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763182AbXHaBRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 21:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbXHaBQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 21:16:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbXHaBQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 21:16:54 -0400
Date: Thu, 30 Aug 2007 18:16:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org
Subject: Re: [patch 0/4] Linux Kernel Markers
Message-Id: <20070830181601.de0d9ffd.akpm@linux-foundation.org>
In-Reply-To: <20070830171240.GA20240@lst.de>
References: <20070827160540.007809201@polymtl.ca>
	<20070830171240.GA20240@lst.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007 19:12:40 +0200 Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Aug 27, 2007 at 12:05:40PM -0400, Mathieu Desnoyers wrote:
> > Hi Andrew,
> > 
> > Here are the Linux Kernel Markers for 2.6.23-rc3-mm1. It depends on the
> > "immediate values" and on the "sorted module list" patches.
> 
> Andrew, any chance to get this into -mm ASAP so we can have it in
> 2.6.24?

Well, we're trying.  It looks like another release of these patches
will be needed, so I'll have a shot at integrating those.

Judging by the number and severity of the bug reports which seem to be
flying past, 2.6.23 isn't exactly imminent.  And I've been basically
off the air this week due lack of electricity (building work).  And
next week won't be seeing a storm of activity..
