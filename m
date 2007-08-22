Return-Path: <linux-kernel-owner+w=401wt.eu-S932670AbXHVUUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbXHVUUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762551AbXHVUUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:20:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:37881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761844AbXHVUUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:20:23 -0400
Date: Wed, 22 Aug 2007 23:14:13 +0200
From: Andi Kleen <ak@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: 2.6.23-rc3-mm1
Message-ID: <20070822211413.GI8058@bingen.suse.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822110348.8fd6a937.randy.dunlap@oracle.com> <20070822113211.9ac85162.akpm@linux-foundation.org> <20070822193857.GC8058@bingen.suse.de> <20070822121731.011cd263.randy.dunlap@oracle.com> <20070822205311.GH8058@bingen.suse.de> <46CC9696.1070107@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CC9696.1070107@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, that works.

Does it also work when you copy the options (except -mcmodel=kernel) 
you see for

rm kernel/unwind.o
make V=1 kernel/unwind.o 

to the test program command line?

If no please check which option makes it fail.

-Andi

