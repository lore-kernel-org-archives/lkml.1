Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbZD0WCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbZD0WCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759063AbZD0WCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:02:33 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45189 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759599AbZD0WCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:02:32 -0400
Date: Tue, 28 Apr 2009 06:57:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 08/14] sh: Use macros for .data.page_aligned section.
Message-ID: <20090427215715.GC5033@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Abbott <tabbott@MIT.EDU>, Sam Ravnborg <sam@ravnborg.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Jeff Arnold <jbarnold@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu> <1240864388-26315-2-git-send-email-tabbott@mit.edu> <1240864388-26315-3-git-send-email-tabbott@mit.edu> <1240864388-26315-4-git-send-email-tabbott@mit.edu> <1240864388-26315-5-git-send-email-tabbott@mit.edu> <1240864388-26315-6-git-send-email-tabbott@mit.edu> <1240864388-26315-7-git-send-email-tabbott@mit.edu> <1240864388-26315-8-git-send-email-tabbott@mit.edu> <1240864388-26315-9-git-send-email-tabbott@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240864388-26315-9-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 04:33:02PM -0400, Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Paul Mundt <lethal@linux-sh.org>
> ---
>  arch/sh/kernel/vmlinux_32.lds.S |    3 +--
>  arch/sh/kernel/vmlinux_64.lds.S |    3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
