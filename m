Return-Path: <linux-kernel-owner+w=401wt.eu-S1762401AbXISRl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762401AbXISRl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763072AbXISRjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:39:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47624 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763322AbXISRjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:39:06 -0400
Date: Wed, 19 Sep 2007 18:39:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 22/24] do_rmdir(): elevate write count
Message-ID: <20070919173905.GV20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182747.9A3B809F@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182747.9A3B809F@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:47AM -0700, Dave Hansen wrote:
> 
> Elevate the write count during the vfs_rmdir() call.

Ok.

