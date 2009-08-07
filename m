Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZHGQuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZHGQuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZHGQuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:50:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754204AbZHGQuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:50:14 -0400
Date: Fri, 7 Aug 2009 09:49:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-06-00-30 uploaded
Message-Id: <20090807094944.eed4bfb8.akpm@linux-foundation.org>
In-Reply-To: <20090807134659.GA2093@darkstar>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
	<20090807134659.GA2093@darkstar>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Aug 2009 21:47:00 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> Hi, andrew
> 
> Booting with this release, init (maybe getty?) reports something like:
> 
> INIT: open /dev/console failed with input/output error
> 
> 2.6.31-rc5 is fine.
> 
> Any hints to find the root problem?

Not really, sorry.  Might be tty changes in linux-next?

> Another problem:
> 
> When I moving mouse or pressing key the screen will become black, then restore the normal screen.

There have been quite a lot of X problems lately.

Could you test the bare linux-next please?
