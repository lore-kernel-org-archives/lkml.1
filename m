Return-Path: <linux-kernel-owner+w=401wt.eu-S1764619AbXFELLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764619AbXFELLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763179AbXFELLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:11:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55994 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762389AbXFELLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:11:15 -0400
Date: Tue, 5 Jun 2007 13:11:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Jeff Dike <jdike@addtoit.com>,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Syslets, signals, and security
Message-ID: <20070605111112.GA24014@one.firstfloor.org>
References: <20070604163145.GA7144@c2.user-mode-linux.org> <20070604174542.GD29201@mami.zabbo.net> <20070604191349.GA8903@c2.user-mode-linux.org> <p73vee3a14x.fsf@bingen.suse.de> <20070604234453.06162eb9@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604234453.06162eb9@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't think it's a good idea.
> 
> Ditto (and glibc handles it for userspace posix APIs)

How?

-Andi

