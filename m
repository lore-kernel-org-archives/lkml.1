Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZIWTy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZIWTy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZIWTyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:54:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56020 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZIWTyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:54:24 -0400
Date: Wed, 23 Sep 2009 15:54:25 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Kyle McMartin <kyle@parisc-linux.org>, Helge Deller <deller@gmx.de>,
       linux-parisc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PARISC: includecheck fix: signal.c
Message-ID: <20090923195424.GH11961@bombadil.infradead.org>
References: <1253626532.3784.17.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253626532.3784.17.camel@ht.satnam>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 07:05:32PM +0530, Jaswinder Singh Rajput wrote:
> 
> fix the following 'make includecheck' warning:
> 
>   arch/parisc/kernel/signal.c: linux/compat.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Applied, thanks.
