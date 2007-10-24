Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbXJXQOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbXJXQOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXJXQOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:14:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48717 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbXJXQOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:14:00 -0400
Date: Wed, 24 Oct 2007 09:10:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-rc1]
 EXPORT_SYMBOL(__set_page_dirty_no_writeback);
Message-ID: <20071024091027.541d2e98@laptopd505.fenrus.org>
In-Reply-To: <200710250015.FFG17175.LSHOMOFVJFOFtQ@I-love.SAKURA.ne.jp>
References: <200710250015.FFG17175.LSHOMOFVJFOFtQ@I-love.SAKURA.ne.jp>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 00:15:55 +0900
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> I think __set_page_dirty_no_writeback should be exported so that
> tmpfs-like filesystems can use it.
> 

which filesystem is ACTUALLY using it?
Please submit the export together with the actual user; we have too
many unused exports already; the only way to remotely deal with that
problem is to merge the exports together with the actual code...

Greetings,
   Arjan van de Ven
