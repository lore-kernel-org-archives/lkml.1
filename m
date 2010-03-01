Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0CACdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 21:33:51 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48091 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0CACdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 21:33:50 -0500
Date: Mon, 1 Mar 2010 11:33:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 42/66] arch/mips/lib/libgcc.h: Checkpatch cleanup
Message-ID: <20100301023316.GB23086@linux-sh.org>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net> <1267289508-31031-43-git-send-email-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267289508-31031-43-git-send-email-andrea.gelmini@gelma.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 05:51:23PM +0100, Andrea Gelmini wrote:
> arch/mips/lib/libgcc.h:21: ERROR: open brace '{' following union go on the same line
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  arch/mips/lib/libgcc.h |    3 +--
>  arch/sh/lib/libgcc.h   |    3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
I'll apply the sh part by itself, and I suppose Ralf will do the same for
MIPS. I'm a bit confused as to why these were lumped together when 65 out
of 66 oneliner patches made no use of ad-hoc grouping.
