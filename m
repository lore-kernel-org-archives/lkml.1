Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbXHRPyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbXHRPyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 11:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXHRPx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 11:53:57 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:42674 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbXHRPx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 11:53:56 -0400
Date: Sun, 19 Aug 2007 00:52:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       Bryan Wu <bryan.wu@analog.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Greg Ungerer <gerg@uclinux.org>,
       Miles Bader <uclinux-v850@lsi.nec.co.jp>
Subject: Re: [PATCH trivial] include/asm-*/system.h: remove unused set_rmb(), set_wmb() macros
Message-ID: <20070818155245.GA27255@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>, trivial@kernel.org,
	linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Greg Ungerer <gerg@uclinux.org>,
	Miles Bader <uclinux-v850@lsi.nec.co.jp>
References: <tkrat.eb667dbcda37eb9d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.eb667dbcda37eb9d@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 05:32:05PM +0200, Stefan Richter wrote:
> These don't appear anywhere else in the kernel anymore.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: Bryan Wu <bryan.wu@analog.com>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
> ---
>  include/asm-sh64/system.h      |    3 +--
> 

Acked-by: Paul Mundt <lethal@linux-sh.org>
