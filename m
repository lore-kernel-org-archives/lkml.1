Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZFAGyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZFAGyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 02:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZFAGx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 02:53:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:53820 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZFAGx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 02:53:56 -0400
Subject: Re: [PATCH 1/2 -tip] headers_check fix: linux/auto_fs.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1242795274.3260.4.camel@localhost.localdomain>
References: <1242795274.3260.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 12:23:25 +0530
Message-Id: <1243839205.3170.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 10:24 +0530, Jaswinder Singh Rajput wrote:
> fix the following 'make headers_check' warnings:
> 
>   usr/include/linux/auto_fs.h:17: include of <linux/types.h> is preferred over <asm/types.h>
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---

I prepared headers-check tree and applied these patches on :

git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/headers-check-2.6.git

I will send headers-check patches to Linus on next merge window.

Thanks,
--
JSR



