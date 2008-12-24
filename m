Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbYLXNWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbYLXNWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 08:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYLXNWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 08:22:34 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54485 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbYLXNWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 08:22:33 -0500
Date: Wed, 24 Dec 2008 14:22:30 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH] UIO: Add missing documentation of features added
	recently
Message-ID: <20081224132230.GA29503@strlen.de>
References: <20081224030400.GB3081@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081224030400.GB3081@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Wed, Dec 24, 2008 at 04:04:03AM +0100, Hans J. Koch wrote:
> The following features were added to the UIO framework in the near past:
> 
> * Generic drivers for platform devices (uio_pdrv, uio_pdrv_genirq)
> * an "offset" sysfs attribute for memory mappings
> 
> Unfortunately, all this went in without documentation (won't happen again...)
> 
> This patch updates UIO documentation.
> 
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Acked-by: Uwe Kleine-König <ukleinek@strlen.de>

for the uio_pdrv part.

Thanks
Uwe
