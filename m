Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbXD0Wfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbXD0Wfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbXD0Wfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:35:30 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55662 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbXD0WfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:35:25 -0400
Subject: Re: [RFC: 2.6 patch] drivers/mtd/maps/nettel.c: possible cleanups
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070426234756.GM3468@stusta.de>
References: <20070426234756.GM3468@stusta.de>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 23:35:13 +0100
Message-Id: <1177713313.2755.681.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 01:47 +0200, Adrian Bunk wrote:
> This patch contains the following possible cleanups:
> - make 2 needlessly global functions static
> - #if 0 the unused nettel_eraseconfig()
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

For obvious reasons I'll apply this only if approved by the owner of the
map driver in question.

-- 
dwmw2

