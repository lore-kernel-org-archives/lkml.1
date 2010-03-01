Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0CAXyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:54:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab0CAXyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:54:09 -0500
Date: Mon, 1 Mar 2010 18:54:07 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] parisc: use __ratelimit
Message-ID: <20100301235407.GC12443@bombadil.infradead.org>
References: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com> <1267354697-6456-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267354697-6456-3-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 07:58:15PM +0900, Akinobu Mita wrote:
> Replace open-coded rate limiting logic with __ratelimit().
> 

Thanks, I'll apply this.

regards, Kyle
