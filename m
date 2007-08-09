Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbXHIU1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbXHIU1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbXHIU04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:26:56 -0400
Received: from eazy.amigager.de ([213.239.192.238]:55139 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbXHIU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:26:55 -0400
Date: Thu, 9 Aug 2007 22:25:43 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Zwell <dzwell@gmail.com>, Oliver Neukum <oliver@neukum.org>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: USB hard disk broken
Message-ID: <20070809202543.GA14289@thinkpad.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Dan Zwell <dzwell@gmail.com>, Oliver Neukum <oliver@neukum.org>,
	David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
References: <46BB47C9.3030609@gmail.com> <Pine.LNX.4.44L0.0708091558260.4244-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708091558260.4244-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 16:00:13 -0400, Alan Stern wrote:

[...]

> What makes you think the problem you see is the same as the one 
> described by Tino?  Do you get the "scatterlist error 0/-121" line in 
> your log?
> 
> Please provide a dmesg log showing your problem with CONFIG_USB_DEBUG 
> enabled.

I'll try to reproduce the problem with the commit reverted, but not
before Sunday evening.

Regards,
Tino
