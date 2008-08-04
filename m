Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbYHDXRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbYHDXRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYHDXRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:17:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601AbYHDXRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:17:05 -0400
Date: Mon, 4 Aug 2008 16:16:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] h8300 update timer handler
Message-Id: <20080804161653.0ee4a3a7.akpm@linux-foundation.org>
In-Reply-To: <87abfu7m4h.wl%ysato@users.sourceforge.jp>
References: <87abfu7m4h.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Aug 2008 00:34:06 -0400 Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> h8300 new timer handlers.
> 
> 1/3 - new timer handler
> 2/3 - delete obsolute files
> 3/3 - misc update

Could you please always describe your changes more completely?

We are provided no explanation of why the old code was removed, why the
new code is added, what problems were fixed, etc.

The way these patches have been documented, I have no way of knowing
whether or not they should be merged into 2.6.27.  Do you think they
should be?  If so, why?

Thanks.
