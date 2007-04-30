Return-Path: <linux-kernel-owner+w=401wt.eu-S1423129AbXD3HnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423129AbXD3HnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423130AbXD3HnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:43:25 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423129AbXD3HnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:43:24 -0400
Date: Mon, 30 Apr 2007 00:43:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernd Eckenfels <ecki@lina.inka.de>
Cc: linux-kernel@vger.kernel.org, Tomasz Chmielewski <mangoo@wpkg.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Linux 2.6.21
Message-Id: <20070430004305.cedb2e9e.akpm@linux-foundation.org>
In-Reply-To: <E1HiNwi-0000Pr-00@calista.eckenfels.net>
References: <20070430030213.GB23336@stusta.de>
	<E1HiNwi-0000Pr-00@calista.eckenfels.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(various cc's reestablished.  Please don't remove cc's when dealing with
kernel people).

On Mon, 30 Apr 2007 06:57:08 +0200 Bernd Eckenfels <ecki@lina.inka.de> wrote:

> In article <20070430030213.GB23336@stusta.de> you wrote:
> > If it is considered useful it shouldn't be a problem to automatically 
> > forward all incoming Bugzilla bugs to linux-kernel.
> 
> Yes, most of it to linux-kernel, some components (netdev@, architecture) to
> a more specific list.
> 

I think it would be a net good thing to send bugme-new notifications to lkml,
actually.  There are only maybe 5-10 per day (mad guess).


