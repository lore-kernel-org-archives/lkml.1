Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbXCTHnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbXCTHnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 03:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXCTHnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 03:43:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59502 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbXCTHnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 03:43:11 -0400
Subject: Re: [PATCH] Complain about missing system calls.
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rmk@arm.linux.org.uk, sam@ravnborg.org
In-Reply-To: <20070319164243.026fdbfd.akpm@linux-foundation.org>
References: <1173394873.3461.510.camel@pmac.infradead.org>
	 <20070319164243.026fdbfd.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 07:43:08 +0000
Message-Id: <1174376588.3392.168.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 16:42 -0700, Andrew Morton wrote:
> hm, did you try running this on x86_64?

I don't have any. I only tested it on PowerPC and i386. Others then
provided more exclusions for SPARC and maybe ARM, although I'm not sure
you have the latter yet. It's not hard to add extra exclusions.

-- 
dwmw2

