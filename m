Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbZISIku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbZISIku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 04:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZISIkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 04:40:49 -0400
Received: from [195.41.46.236] ([195.41.46.236]:52037 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbZISIks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 04:40:48 -0400
Date: Sat, 19 Sep 2009 10:40:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] h8300: Cleanup linker script using new linker script
	macros.
Message-ID: <20090919084046.GE25840@merkur.ravnborg.org>
References: <1253306779-7517-1-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253306779-7517-1-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 04:46:19PM -0400, Tim Abbott wrote:
> This cross-architecture linker script cleanup project is in
> preparation for adding support for building the kernel with
> -ffunction-sections -fdata-sections, which is a prerequisite for
> Ksplice.
> 
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
