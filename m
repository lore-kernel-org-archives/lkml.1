Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbXGCOO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbXGCOO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbXGCOOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:14:41 -0400
Received: from verein.lst.de ([213.95.11.210]:45307 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758240AbXGCOOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:14:40 -0400
Date: Tue, 3 Jul 2007 16:13:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: How to handle patches that cross maintainers?
Message-ID: <20070703141351.GB18565@lst.de>
References: <4BEFAFC6-3346-4F29-B1C5-377952E3FBBF@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEFAFC6-3346-4F29-B1C5-377952E3FBBF@kernel.crashing.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 04:01:20AM -0500, Kumar Gala wrote:
> Andrew,
> 
> I was hoping to get your input on how to handle patches that cross  
> maintainers.  I've got a patch that is pretty PPC specific, but  
> happens to touch some drivers as well.

I think the real question is why the heck does it touch those drivers?
:)

