Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab0APAGn (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 19:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652Ab0APAGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 19:06:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758357Ab0APAGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 19:06:41 -0500
Date: Fri, 15 Jan 2010 16:06:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ian@mnementh.co.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
        pierre@ossman.eu
Subject: Re: [PATCH 03/03] mmc: Balance tmio-mmc cell enable()/disable()
 calls
Message-Id: <20100115160602.f1523a68.akpm@linux-foundation.org>
In-Reply-To: <20091127050022.15251.43017.sendpatchset@rxone.opensource.se>
References: <20091127045956.15251.84958.sendpatchset@rxone.opensource.se>
	<20091127050022.15251.43017.sendpatchset@rxone.opensource.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009 14:00:22 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
> 
> This patch adds cell->disable() calls to the tmio-mmc
> probe() error handling and the remove() function.
> 

This patch still doesn't apply due to linux-next changes which never
got merged into 2.6.33-rcX.

If you think it should go into 2.6.33 then please redo a patch against
mainline and we'll cheerily trash the problematic stuff in linux-next.
