Return-Path: <linux-kernel-owner+w=401wt.eu-S965650AbXEAIq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965650AbXEAIq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965661AbXEAIq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:46:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47553 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965650AbXEAIq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:46:27 -0400
Date: Tue, 1 May 2007 09:46:23 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-pcmcia@lists.infradead.org
Subject: pcmcia ioctl removal
Message-ID: <20070501084623.GB14364@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pcmcia@lists.infradead.org
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

>  pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch

...

> Dominik is busy.  Will probably re-review and send these direct to Linus.

The patch above is the removal of cardmgr support.  While I'd love to
see this cruft gone it definitively needs maintainer judgement on whether
they time has come that no one relies on cardmgr anymore.

