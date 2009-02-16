Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZBPVla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZBPVla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZBPVlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:41:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:41988 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZBPVlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:41:21 -0500
Date: Mon, 16 Feb 2009 13:41:29 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Bob Wilkinson <bob@fourtheye.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] Multiple BUG: unable to handle kernel paging request
Message-ID: <20090216134129.6f9e7458@infradead.org>
In-Reply-To: <20090216211012.GA31416@fourtheye.org>
References: <20090216211012.GA31416@fourtheye.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 21:10:12 +0000
Bob Wilkinson <bob@fourtheye.org> wrote:

> Hello
> 
>      I have been having many problems with the stability of one of
> my machines. It does have a lot of attached peripherals, and
> regularly crashes. It does not always boot. I have attached as much
> information as I know to.
> 
> There are multiple 
> 
> BUG: unable to handle kernel paging request 

you're using a rather old kernel; it might be better to report such an
issue to your distribution instead.


however, one thing to try is to put "mem=750M" on the kernel command
line; if your bios lies to you about how much memory you have that
would work around it.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
