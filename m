Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbXEUQm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbXEUQm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbXEUQmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:42:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36595 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872AbXEUQmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:42:21 -0400
Date: Mon, 21 May 2007 17:41:29 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Davi Arnaut <davi@haxent.com.br>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] shrink task_struct by 16 bytes
Message-ID: <20070521164129.GA29577@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Davi Arnaut <davi@haxent.com.br>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <464FC31B.9000609@haxent.com.br> <20070521100400.GA11351@infradead.org> <4651C8CA.7020001@haxent.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4651C8CA.7020001@haxent.com.br>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.
