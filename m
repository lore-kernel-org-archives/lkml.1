Return-Path: <linux-kernel-owner+w=401wt.eu-S1762420AbXISRdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762420AbXISRdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761876AbXISRca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:32:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58946 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761665AbXISRc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:32:29 -0400
Date: Wed, 19 Sep 2007 18:32:28 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 09/24] elevate mnt writers for callers of vfs_mkdir()
Message-ID: <20070919173228.GI20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182729.14AEDAFA@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182729.14AEDAFA@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:29AM -0700, Dave Hansen wrote:
> 
> Pretty self-explanatory.  Fits in with the rest of the series.

Ok.

