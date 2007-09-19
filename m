Return-Path: <linux-kernel-owner+w=401wt.eu-S1762919AbXISRgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762919AbXISRgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762536AbXISReK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:34:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58976 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbXISReI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:34:08 -0400
Date: Wed, 19 Sep 2007 18:34:07 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 12/24] elevate mount count for extended attributes
Message-ID: <20070919173407.GL20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182733.19AE94A2@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182733.19AE94A2@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:33AM -0700, Dave Hansen wrote:
> 
> This basically audits the callers of xattr_permission(), which
> calls permission() and can perform writes to the filesystem.

Ok.

