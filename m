Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZA2SiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZA2SiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZA2Shw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:37:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751400AbZA2Shw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:37:52 -0500
Date: Thu, 29 Jan 2009 10:37:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: Re: [patch 1/2] epoll fix own poll()
Message-Id: <20090129103715.2d3a8274.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0901291030390.15448@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com>
	<20090129000120.da7d249d.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0901290956530.15448@alien.or.mcafeemobile.com>
	<20090129102726.5f4a0040.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0901291030390.15448@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 10:32:38 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:

> On Thu, 29 Jan 2009, Andrew Morton wrote:
> 
> > But which kernel version are you looking to get this merged into?
> 
> The limit reworking one, ASAP. The epoll poll fix, dunno.
> I'd like to see it staged in your tree for a bit. How much timeframe 
> difference are we looking at, from .29 to .30?

The usual - 2.5 months(ish)

What is the impact of the bug which this patch fixes?

