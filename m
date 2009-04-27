Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbZD0WC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbZD0WC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZD0WCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:02:19 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45181 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZD0WCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:02:18 -0400
Date: Tue, 28 Apr 2009 06:57:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 02/14] sh: Use macros for .bss.page_aligned section.
Message-ID: <20090427215701.GB5033@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Abbott <tabbott@MIT.EDU>, Sam Ravnborg <sam@ravnborg.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Jeff Arnold <jbarnold@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu> <1240864388-26315-2-git-send-email-tabbott@mit.edu> <1240864388-26315-3-git-send-email-tabbott@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240864388-26315-3-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 04:32:56PM -0400, Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Paul Mundt <lethal@linux-sh.org>
> ---
>  arch/sh/kernel/irq.c            |    6 ++----
>  arch/sh/kernel/vmlinux_32.lds.S |    2 +-
>  arch/sh/kernel/vmlinux_64.lds.S |    2 +-
>  3 files changed, 4 insertions(+), 6 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
