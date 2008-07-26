Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYGZQjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYGZQjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYGZQj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:39:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40975 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYGZQj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:39:27 -0400
Date: Sat, 26 Jul 2008 17:26:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tim@physik3.uni-rostock.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nwflash: fix build errors and warning
Message-ID: <20080726162649.GF8871@flint.arm.linux.org.uk>
References: <200807250848.m6P8mIWF001718@imap1.linux-foundation.org> <20080726141808.GB8871@flint.arm.linux.org.uk> <20080726150155.GA3562@localhost.localdomain> <20080726165258.2dacff67@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726165258.2dacff67@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 04:52:58PM +0100, Alan Cox wrote:
> 
> > Sorry. I'm preparing cross compiler. But this patch should fix this
> > problem.
> 
> nwflash is a flash programming driver. Any changes to it should be
> rigorously tested or obviously correct because you can brick a netwindup
> if you get it wrong.

Indeed.

As I understand the situation, there's only one person (in Canada) who
has the technology to unbrick them... which is a rather expensive
solution for folk this side of the pond.
