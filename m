Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYJCAxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYJCAxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 20:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbYJCAxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 20:53:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34053 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbYJCAxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 20:53:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Kees Cook <kees.cook@canonical.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
In-Reply-To: Kees Cook's message of  Thursday, 2 October 2008 17:16:16 -0700 <20081003001616.GN10632@outflux.net>
References: <20081001201116.GD12527@outflux.net>
	<48E3EFD6.2010704@redhat.com>
	<20081001215657.GH12527@outflux.net>
	<20081001220948.GC32107@sunsite.ms.mff.cuni.cz>
	<20081001222706.68E7E1544B4@magilla.localdomain>
	<20081003001616.GN10632@outflux.net>
Emacs: well, why *shouldn't* you pay property taxes on your editor?
Message-Id: <20081003005258.7FEDE154212@magilla.localdomain>
Date: Thu,  2 Oct 2008 17:52:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the safe available AT_* values to use are 25, 26.

I would configure the size in bytes.  Ulrich suggested it be 16 bytes on
both 32-bit and 64-bit machines.


Thanks,
Roland
