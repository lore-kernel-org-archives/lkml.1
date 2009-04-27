Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbZD0BSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbZD0BSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 21:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZD0BSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 21:18:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260AbZD0BSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 21:18:42 -0400
Date: Sun, 26 Apr 2009 18:16:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: forcedeth, 2.6.29.1: no link during initialization
Message-Id: <20090426181604.7b38cab0.akpm@linux-foundation.org>
In-Reply-To: <49F066D8.5060802@t-online.de>
References: <49F066D8.5060802@t-online.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Thu, 23 Apr 2009 15:02:16 +0200 Harald Dunkel <harald.dunkel@t-online.de> wrote:

> Hi folks,
> 
> I get these messages on every boot
> 
> [   37.413903] eth0: no link during initialization.
> [   39.789316] eth0: link up.
> [   39.794965] eth0: link down.
> [   46.438599] eth0: link up.
> [   48.407885] eth0: link down.
> [   52.981754] eth0: link up.
> [   52.986966] eth0: link down.
> 
> After that dhcpclient or network manager give up to try
> again, i.e. the network is not set up.
> 
> 
> I saw this mentioned several times on Google, but without
> a solution. Maybe I could help to track this down?


