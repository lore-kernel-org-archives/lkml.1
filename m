Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbYCAOuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbYCAOuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 09:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYCAOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 09:49:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45913 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYCAOt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 09:49:59 -0500
Subject: Re: [IA64] fix userspace compile error in gcc_intrin.h
From: David Woodhouse <dwmw2@infradead.org>
To: Doug Chapman <doug.chapman@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
In-Reply-To: <1204310490.8186.11.camel@athlon>
References: <200802052007.m15K7vuv005319@hera.kernel.org>
	 <1204309483.18955.66.camel@shinybook.infradead.org>
	 <1204310490.8186.11.camel@athlon>
Content-Type: text/plain
Date: Sat, 01 Mar 2008 14:49:50 +0000
Message-Id: <1204382990.3891.3.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 13:41 -0500, Doug Chapman wrote:
> Thanks for catching that.  I will post a patch for the Kbuild part
> later today.

There's also a bunch of other stuff in that file which looks like
perhaps it shouldn't be exposed to userspace.

-- 
dwmw2

