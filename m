Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZGKBmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZGKBmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 21:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZGKBma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 21:42:30 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46675 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZGKBm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 21:42:29 -0400
Date: Sat, 11 Jul 2009 10:42:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-sh@vger.kernel.org, Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] sh: Clean up linker script using new linker script macros.
Message-ID: <20090711014204.GA26706@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org,
	Sam Ravnborg <sam@ravnborg.org>, linux-sh@vger.kernel.org,
	Anders Kaseorg <andersk@ksplice.com>
References: <alpine.DEB.1.10.0907082333190.6580@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0907082333190.6580@vinegar-pot.mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 10:45:59AM -0400, Tim Abbott wrote:
> This patch converts the sh architecture to use the new linker script 
> macros in include/asm-generic/vmlinux.lds.h.
> 
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: linux-sh@vger.kernel.org

Applied, thanks.
