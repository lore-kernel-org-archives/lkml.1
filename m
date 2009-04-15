Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbZDOBTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbZDOBTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZDOBTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:19:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503AbZDOBS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:18:59 -0400
Date: Tue, 14 Apr 2009 18:17:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alessandro Suardi <alessandro.suardi@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc2
In-Reply-To: <5a4c581d0904141722g12e791eha4fa0fb206769ce5@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904141816400.4132@localhost.localdomain>
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain> <5a4c581d0904141722g12e791eha4fa0fb206769ce5@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, Alessandro Suardi wrote:
>
> arch/x86/kernel/traps.c:57:28: error: asm/mach_traps.h: No such file or directory

Hmm. You should have a file called:

	arch/x86/include/asm/mach_traps.h

no?

		Linus
