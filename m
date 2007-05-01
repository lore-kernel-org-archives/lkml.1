Return-Path: <linux-kernel-owner+w=401wt.eu-S965661AbXEAIzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661AbXEAIzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXEAIzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:55:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55975 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbXEAIzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:55:44 -0400
Date: Tue, 1 May 2007 09:55:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: consolidate-generic_writepages-and-mpage_writepages.patch
Message-ID: <20070501085543.GE14364@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  consolidate-generic_writepages-and-mpage_writepages.patch
> 
> Might merge.  I forget what happened to this.

ACK from me on this one.

