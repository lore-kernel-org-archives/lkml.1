Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbYBKXUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbYBKXUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbYBKXUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:20:13 -0500
Received: from barikada.upol.cz ([158.194.242.200]:57612 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYBKXUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:20:12 -0500
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kbuild: fix make V=1
In-Reply-To: <20080211164709.GA22359@uranus.ravnborg.org>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080211133137.GB20959@uranus.ravnborg.org> <20080211164709.GA22359@uranus.ravnborg.org>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Tue, 12 Feb 2008 00:38:24 +0100
Message-Id: <E1JOiEG-0000do-0W@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Date: Mon, 11 Feb 2008 17:47:09 +0100
[]
> Mike spotted another missing thing from his initial
> patch so I folded it into the fix and pushed out
> a new kbuild.git tree.
>
> See updated patch below.
>
> 	Sam

Sam, do you agree my fix was more reliable (yea, not only efficient:)?

On cost of one new line in silent mode, one gets working "V=1" (and
all others).
_____
