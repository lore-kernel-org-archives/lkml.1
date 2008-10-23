Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYJWVab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYJWVab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYJWVaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:30:23 -0400
Received: from h4.dl5rb.org.uk ([81.2.74.4]:36461 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751378AbYJWVaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:30:22 -0400
Date: Thu, 23 Oct 2008 22:30:17 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mips: fix build error on malta
Message-ID: <20081023213017.GA10903@linux-mips.org>
References: <48FD1C77.6070601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FD1C77.6070601@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 02:04:07AM +0200, Frederic Weisbecker wrote:

> This patch corrects the path for mips headers in 
> arch/mips/mti-malta/malta-amon.c
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks for your patch.  I've already got an equivalent patch commited; it
just hasn't yet made it to kernel.org.

Please always cc MIPS patches to linux-mips@linux-mips.org.

  Ralf
