Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbXGRUt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbXGRUt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbXGRUtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:49:16 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:46185 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbXGRUtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:49:15 -0400
Message-ID: <469E7C82.5020400@pimpmylinux.org>
Date: Wed, 18 Jul 2007 22:48:02 +0200
From: Gabriel C <crazy@pimpmylinux.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH] net/, drivers/net/ , missing EXPERIMENTAL in menus
References: <469E75AA.7040109@pimpmylinux.org> <Pine.LNX.4.64.0707181620460.13912@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707181620460.13912@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Wed, 18 Jul 2007, Gabriel C wrote:
> 
>> Everything 'depends on' EXPERIMENTAL should be marked as such,
>> visible in the menus.
> 
> rather than add all that extraneous dreck to the Kconfig files, i
> *really* wish folks would give serious thought to my earlier
> suggestion about a "maturity level" attribute that could be used to
> not only add a parenthesized maturity level during display, but could
> also be used to activate/deactivate entire levels in one operation.
> 
> there's no point adding all that redundant content when it can all be
> done automatically.


I don't know what your suggestion was , I'm sorry.

It may be for sure a good idea to add all this maturity levels
automatically but for now such an thing does not exists.

> 
> rday


Gabriel
