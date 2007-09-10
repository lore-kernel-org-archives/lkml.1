Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXIJKUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXIJKUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXIJKTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:19:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56934 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbXIJKTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:19:54 -0400
Subject: Re: [PATCH] add page->mapping handling interface [22/35] changes
	in JFFS2
From: David Woodhouse <dwmw2@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20070910191622.d18b1aaa.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
	 <20070910191622.d18b1aaa.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 11:19:51 +0100
Message-Id: <1189419591.8320.161.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-10 at 19:16 +0900, KAMEZAWA Hiroyuki wrote:
> Changes page->mapping handling in JFFS2
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Looks reasonable to me; I assume it's not intended for me to take it and
apply it yet, before the core parts are merged? I'll let you shepherd it
upstream...

-- 
dwmw2

