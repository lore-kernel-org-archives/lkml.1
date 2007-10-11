Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbXJKRVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbXJKRVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 13:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbXJKRV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 13:21:26 -0400
Received: from saeurebad.de ([85.214.36.134]:54360 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359AbXJKRV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 13:21:26 -0400
Date: Thu, 11 Oct 2007 19:21:21 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: Fix printk format strings
Message-ID: <20071011172121.GC28048@saeurebad.de>
Mail-Followup-To: Vegard Nossum <vegard.nossum@gmail.com>,
	trivial@kernel.org, linux-kernel@vger.kernel.org
References: <1192083422.26648.19.camel@grianne>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192083422.26648.19.camel@grianne>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 11, 2007 at 08:17:02AM +0200, Vegard Nossum wrote:
> This makes sure printk format strings are string literals containing no
> more than a single line.

Perhaps you should write _why_ one-line printk()s are even needed, with
profound reasons instead of constantly talking about mysterious later changes
that you will propose any time soon.

	Hannes
