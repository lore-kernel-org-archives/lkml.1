Return-Path: <linux-kernel-owner+w=401wt.eu-S933472AbXCENXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbXCENXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933473AbXCENXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:23:16 -0500
Received: from ns1.suse.de ([195.135.220.2]:49216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933472AbXCENXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:23:15 -0500
Date: Mon, 5 Mar 2007 15:22:43 +0100
From: Andi Kleen <ak@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, ak@suse.de, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: Re: [PATCH] x86_64: shut up vm86(2)
Message-ID: <20070305142243.GB22829@bingen.suse.de>
References: <20070228214046.GA5539@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228214046.GA5539@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 12:40:46AM +0300, Alexey Dobriyan wrote:
> From originally rate-limited printk, to just printk, to current version.
> Everybody had enough time to learn about vm86(2) absense.

I don't think that's true. I prefer to keep the message.

-Andi
