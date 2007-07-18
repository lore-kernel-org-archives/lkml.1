Return-Path: <linux-kernel-owner+w=401wt.eu-S1765788AbXGRBot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765788AbXGRBot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 21:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXGRBom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 21:44:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755315AbXGRBol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 21:44:41 -0400
Date: Tue, 17 Jul 2007 18:44:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tony Breeds <tony@bakeyournoodle.com>
cc: Bret Towe <magnade@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: 2.6.22-git ppc build failure
In-Reply-To: <20070718010355.GV10345@bakeyournoodle.com>
Message-ID: <alpine.LFD.0.999.0707171843370.27353@woody.linux-foundation.org>
References: <dda83e780707171104g10372341l7d2225f172153a6b@mail.gmail.com>
 <20070718010355.GV10345@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Tony Breeds wrote:
> 
> Fix compile failure in arch/powerpc/kernel/pci-common.c

Thanks. I assume this has been boot-tested too, and everything else from 
the PCI merge was ok?

		Linus
