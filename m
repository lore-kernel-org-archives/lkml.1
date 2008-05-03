Return-Path: <linux-kernel-owner+w=401wt.eu-S1765232AbYECR6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765232AbYECR6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYECR6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:58:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587AbYECR6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:58:10 -0400
Date: Sat, 3 May 2008 10:57:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Carlos R. Mafra" <crmafra@ift.unesp.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/time.c: Silence gcc warning 'integer constant to
 large for long type'
In-Reply-To: <481BA272.6080905@zytor.com>
Message-ID: <alpine.LFD.1.10.0805031056590.5994@woody.linux-foundation.org>
References: <200805021858.m42Iw4Lj025952@tazenda.hos.anvin.org> <alpine.LFD.1.10.0805021407030.5994@woody.linux-foundation.org> <481B888F.3070302@zytor.com> <alpine.LFD.1.10.0805021515120.5994@woody.linux-foundation.org> <alpine.LFD.1.10.0805021528080.5994@woody.linux-foundation.org>
 <481BA272.6080905@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 May 2008, H. Peter Anvin wrote:
> 
> Updated git tree now available.  The timeconst patch (the only one that has
> changed) is attached.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-inttypes.git

Thanks, much better. Pulled.

		Linus
