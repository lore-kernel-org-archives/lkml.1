Return-Path: <linux-kernel-owner+w=401wt.eu-S935002AbXGUJu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935002AbXGUJu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 05:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932175AbXGUJus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 05:50:48 -0400
Received: from barikada.upol.cz ([158.194.242.200]:57814 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759109AbXGUJur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 05:50:47 -0400
Date: Sat, 21 Jul 2007 12:04:22 +0200
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kbuild-devel] [PATCH 25/33] kbuild: use POSIX BRE in headers install target
Message-ID: <20070721100422.GK475@flower.upol.cz>
References: <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org> <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org> <E1ICAEU-0005an-5F@flower> <8bd0f97a0707210127m565f9b2cnc7a8a203f671e948@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0707210127m565f9b2cnc7a8a203f671e948@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 04:27:31AM -0400, Mike Frysinger wrote:
[] 
> if you want to make some micro optimization in the build install step,
> sure ... but functionally, the difference is irrelevant considering
> sed operates only on individual lines

That was an attempt to support less sucking userspace in the kernel
development. More readable, more memory/cpu effective, more portable.
____
