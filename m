Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbXISRiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbXISRiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762536AbXISRgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:36:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59023 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762907AbXISRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:36:18 -0400
Date: Wed, 19 Sep 2007 18:36:15 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 17/24] elevate writer count for do_sys_truncate()
Message-ID: <20070919173615.GQ20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182740.4A667070@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182740.4A667070@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok.
