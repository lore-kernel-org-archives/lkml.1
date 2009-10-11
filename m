Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbZJKMTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbZJKMTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 08:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759306AbZJKMTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 08:19:39 -0400
Received: from verein.lst.de ([213.95.11.210]:53131 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759142AbZJKMTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 08:19:39 -0400
Date: Sun, 11 Oct 2009 14:17:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Thomas Neumann <tneumann@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com, Christoph Hellwig <hch@lst.de>
Subject: Re: deadlock with fallocate
Message-ID: <20091011121752.GA3202@lst.de>
References: <hah08m$p1a$1@ger.gmane.org> <20091011005746.56cd3cd4.akpm@linux-foundation.org> <200910111053.57159.tneumann@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910111053.57159.tneumann@users.sourceforge.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, I'll look at this ASAP.  It's been a bit of a busy time, just
returning from a conference.  Any sort of self-contained testcase would
be perfect, though.

