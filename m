Return-Path: <linux-kernel-owner+w=401wt.eu-S1763577AbXJTNQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763577AbXJTNQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 09:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXJTNQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 09:16:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33500 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbXJTNQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 09:16:41 -0400
Subject: Re: BUG at mm/filemap.c:1749 (2.6.24, jffs2, unionfs)
From: David Woodhouse <dwmw2@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, jffs-dev@axis.com,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <200710191738.l9JHccYx011061@agora.fsl.cs.sunysb.edu>
References: <200710191738.l9JHccYx011061@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 14:16:35 +0100
Message-Id: <1192886195.26380.21.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-8.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-19 at 13:38 -0400, Erez Zadok wrote:
> Nick, the patch worked.  All of my unionfs-over-jffs2 tests passed.

Can I have a Signed-off-by: for it please?

-- 
dwmw2

