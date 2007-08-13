Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbXHMUy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbXHMUy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765999AbXHMUxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:53:48 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3684 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965799AbXHMUxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:53:46 -0400
Subject: Re: [PATCH] [467/2many] MAINTAINERS - SVGA HANDLING
From: Joe Perches <joe@perches.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>, hpa@xytor.com
Cc: Martin Mares <mj@ucw.cz>, torvalds@linux-foundation.org,
       linux-video@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1187036301.5058.5.camel@daplas>
References: <46bffc09.olZ/JU6zLi5nghOY%joe@perches.com>
	 <mj+md-20070813.084046.10732.nikam@ucw.cz>
	 <1187028193.10249.197.camel@localhost>  <1187036301.5058.5.camel@daplas>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 13:27:08 -0700
Message-Id: <1187036828.10249.297.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 04:18 +0800, Antonino A. Daplas wrote:
> video.S is no more. Replaced by arch/i386/boot/video-*.c

SVGA HANDLING
P:	Martin Mares
M:	mj@ucw.cz
L:	linux-kernel@vger.kernel.org
S:	Maintained
F:	Documentation/svga.txt

H. Peter Anvin is added via the arch/i386/boot/
That's probably good enough.

Martin, do you still want to be CC'd on changes
to arch/i386/boot/vid* here?

