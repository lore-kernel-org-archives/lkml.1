Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbYAJIjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbYAJIjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYAJIjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:39:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55254 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYAJIjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:39:36 -0500
Date: Thu, 10 Jan 2008 08:39:34 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch]  Add a simple backtrace test module
Message-ID: <20080110083934.GC10745@infradead.org>
References: <20080109224208.541a659f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109224208.541a659f@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 10:42:08PM -0800, Arjan van de Ven wrote:
> 
> Subject: Add a simple backtrace test module
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> During the work on the x86 32 and 64 bit backtrace code I found it useful
> to have a simple test module to test a process and irq context backtrace.
> Since the existing backtrace code was buggy, I figure it might be useful
> to have such a test module in the kernel so that maybe we can even
> detect such bugs earlier..

Care to add new testcases to a new tests/ subdirectory so we can have
them in one place?
