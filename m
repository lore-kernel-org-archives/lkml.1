Return-Path: <linux-kernel-owner+w=401wt.eu-S1751170AbZH0Ftn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbZH0Ftn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 01:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZH0Ftm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 01:49:42 -0400
Received: from tundra.namei.org ([65.99.196.166]:51329 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZH0Ftm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 01:49:42 -0400
Date: Thu, 27 Aug 2009 15:47:45 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kyle McMartin <kyle@mcmartin.ca>, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org, eparis@redhat.com,
       torvalds@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] allow disabling IMA at runtime
In-Reply-To: <20090826170225.7574759e.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.00.0908271543560.22292@tundra.namei.org>
References: <20090826021005.GD19494@bombadil.infradead.org> <20090826170225.7574759e.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, do we still need this now the memory leak is fixed upstream?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=53a7197aff20e341487fca8575275056fe1c63e5


-- 
James Morris
<jmorris@namei.org>
