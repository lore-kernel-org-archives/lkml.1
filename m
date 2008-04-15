Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbYDOAbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbYDOAbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 20:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbYDOAbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 20:31:31 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3762 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbYDOAba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 20:31:30 -0400
Date: Mon, 14 Apr 2008 20:28:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: Re: w35und: add softmac interface
Message-ID: <20080415002826.GC4270@tuxdriver.com>
References: <20080414224740.GA31431@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414224740.GA31431@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 12:47:40AM +0200, Pavel Machek wrote:
> Hi!
> 
> This adds softmac interface to w35und driver... so it becomes monster
> driver with _two_ interfaces.
> 
> If you initialize hardmac interface, then softmac starts to
> works... it associates to AP, and can even ping.
> 
> (Or at least I hope so... it was somewhat too easy.)
> 
> 								Pavel

OK, I'm late to the party...what is this stuff going into
drivers/net/wireless?

John
-- 
John W. Linville
linville@tuxdriver.com
