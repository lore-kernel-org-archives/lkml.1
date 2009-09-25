Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbZIYB6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbZIYB6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 21:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZIYB6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 21:58:38 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33665 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZIYB6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 21:58:37 -0400
Date: Fri, 25 Sep 2009 10:58:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>, linux-sh@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SH: includecheck fix: dwarf.c
Message-ID: <20090925015809.GB12099@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Matt Fleming <matt@console-pimps.org>, linux-sh@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <1253627426.3784.24.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253627426.3784.24.camel@ht.satnam>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 07:20:26PM +0530, Jaswinder Singh Rajput wrote:
> 
> fix the following 'make includecheck' warning:
> 
>   arch/sh/kernel/dwarf.c: asm/dwarf.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Applied, thanks.
