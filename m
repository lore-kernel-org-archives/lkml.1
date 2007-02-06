Return-Path: <linux-kernel-owner+w=401wt.eu-S1030592AbXBFXtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030592AbXBFXtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030607AbXBFXtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:49:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40337 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030592AbXBFXtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:49:13 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070206154146.c62012b4.randy.dunlap@oracle.com>
References: <1170801484.29759.1000.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>
	 <1170803515.29759.1032.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org>
	 <1170804983.29759.1051.camel@pmac.infradead.org>
	 <20070206154146.c62012b4.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 23:49:05 +0000
Message-Id: <1170805745.29759.1052.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 15:41 -0800, Randy Dunlap wrote:
> It's quite subjective.  E.g., I made/submitted a patch maybe 1 year
> ago that tried to put all video graphics (frame buffer, AGP, DRM/DRI,
> etc.) into one localized place in the menu structure.
> OK, perhaps I wasn't persistent enough, but no one was interested
> in it.  (That probably just means that config menus are low
> priority.) 

Compared with making the bloody _code_ actually cooperate, in that
particular respect, I think the config options are indeed a fairly low
priority :)

-- 
dwmw2

