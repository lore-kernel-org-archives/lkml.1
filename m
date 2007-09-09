Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbXIITIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbXIITIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 15:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758794AbXIITHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 15:07:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53878 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792AbXIITHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 15:07:53 -0400
Date: Sun, 9 Sep 2007 20:06:06 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@redhat.com
Subject: Re: [PATCH] [Bug 8998] Mutex documentation is unclear about
 software interrupts, tasklets and timers in Linux 2.6.23-rc
Message-ID: <20070909200606.74a824d0@laptopd505.fenrus.org>
In-Reply-To: <643744.22696.qm@web52007.mail.re2.yahoo.com>
References: <643744.22696.qm@web52007.mail.re2.yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007 12:02:53 -0700 (PDT)
Matti Linnanvuori <mattilinnanvuori@yahoo.com> wrote:

Hi,

thank you for improving the documentation


> diff -uprN linux-2.6.23/Documentation/mutex-design.txt
> linux-2.6.23-patched/Documentation/mutex-design.txt ---
> 
> 
> Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
> 

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
