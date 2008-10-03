Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYJCUW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYJCUW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYJCUWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:22:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45930 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbYJCUWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:22:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Kees Cook <kees.cook@canonical.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
In-Reply-To: Kees Cook's message of  Thursday, 2 October 2008 22:15:43 -0700 <20081003051543.GQ10632@outflux.net>
References: <20081001201116.GD12527@outflux.net>
	<48E3EFD6.2010704@redhat.com>
	<20081001215657.GH12527@outflux.net>
	<20081001220948.GC32107@sunsite.ms.mff.cuni.cz>
	<20081001222706.68E7E1544B4@magilla.localdomain>
	<20081003001616.GN10632@outflux.net>
	<20081003005258.7FEDE154212@magilla.localdomain>
	<20081003051543.GQ10632@outflux.net>
Emacs: because one operating system isn't enough.
Message-Id: <20081003202213.4AF7E154242@magilla.localdomain>
Date: Fri,  3 Oct 2008 13:22:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Out of curiosity, why are there gaps?  I figure I can include some
> comments in that header to explain the gaps for future AT_* creations.

There are some values defined only on one particular arch.
