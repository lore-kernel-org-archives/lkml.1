Return-Path: <linux-kernel-owner+w=401wt.eu-S1760689AbYBAHJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbYBAHJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYBAHJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:09:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38047 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260AbYBAHJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:09:11 -0500
Date: Thu, 31 Jan 2008 23:08:03 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25
Message-ID: <20080131230803.46c5585d@extreme>
In-Reply-To: <1201829922.23523.68.camel@brick>
References: <1201829922.23523.68.camel@brick>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ping?
> What:   sk98lin network driver
> When:   Feburary 2008
> Why:    In kernel tree version of driver is unmaintained. Sk98lin driver
> 	replaced by the skge driver. 
> Who:    Stephen Hemminger <shemminger@linux-foundation.org>
> 

Sent a removal patch to Jeff, it probably was too big for the mailing list.
-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
