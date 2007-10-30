Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbXJ3Bbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbXJ3Bbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 21:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXJ3Bbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 21:31:44 -0400
Received: from pip9.gyao.ne.jp ([61.122.117.247]:53685 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751347AbXJ3Bbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 21:31:43 -0400
X-Greylist: delayed 2409 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 21:31:43 EDT
Date: Tue, 30 Oct 2007 09:51:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-sh <linuxsh-dev@lists.sourceforge.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix maple bus compiler warning
Message-ID: <20071030005107.GD13661@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-sh <linuxsh-dev@lists.sourceforge.net>,
	linux-kernel@vger.kernel.org
References: <8b67d60710280724s761f1d29t9de57941a9800913@mail.gmail.com> <1193530224.6094.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60710280724s761f1d29t9de57941a9800913@mail.gmail.com> <1193530224.6094.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 02:24:10PM +0000, Adrian McMenamin wrote:
> The API for uevent has changed for 2.6.24 and this patch makes a
> consequential clean up.
> 
> (Apols to linux-sh list users seeing this for the second time, I
> should have included lkml first time round for completeness)
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
Applied, thanks.
