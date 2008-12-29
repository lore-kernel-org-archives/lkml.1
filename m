Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYL2NYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYL2NYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYL2NYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:24:11 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:56942 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYL2NYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:24:10 -0500
Date: Mon, 29 Dec 2008 14:25:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       mj@ucw.cz
Subject: Re: [PATCH] move arch/x86/pci/pci.h to arch/x86/include/asm/pci_x86.h
Message-ID: <20081229132541.GB6938@uranus.ravnborg.org>
References: <1230382948.3373.1.camel@jaswinder.satnam> <20081229121218.GB9628@elte.hu> <20081229122251.GA13687@elte.hu> <20081229125411.GA1852@uranus.ravnborg.org> <20081229125921.GB23674@elte.hu> <20081229130133.GA26634@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229130133.GA26634@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > you mean:
> > 
> >   git format-patch --stdout -1 -M -B -C <sha1>
> 
> also, this does not result in a patch that will be applied properly by the 
> usual patch-tools that people use when they pick up patches from email. So 
> i'll just keep my old script ;-)
I sometimes forget about the stoneage....

	Sam
