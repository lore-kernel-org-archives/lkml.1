Return-Path: <linux-kernel-owner+w=401wt.eu-S1763719AbXISRk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763719AbXISRk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763445AbXISRi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:38:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47622 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760786AbXISRiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:38:55 -0400
Date: Wed, 19 Sep 2007 18:38:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 21/24] elevate mnt writers for vfs_unlink() callers
Message-ID: <20070919173854.GU20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182746.7B3BBFCC@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182746.7B3BBFCC@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:46AM -0700, Dave Hansen wrote:
> 
> 
> Signed-off-by: Dave Hansen <haveblue@us.ibm.com>

Ok.

