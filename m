Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbZGGPb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbZGGPb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbZGGPbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:31:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60202 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757447AbZGGPbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:31:48 -0400
Date: Tue, 7 Jul 2009 11:31:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Michael S. Zick" <lkml@morethan.org>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Null Pointer BUG in uhci_hcd
In-Reply-To: <200907071023.24243.lkml@morethan.org>
Message-ID: <Pine.LNX.4.44L0.0907071130550.8221-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Michael S. Zick wrote:

> Got it.
> Anything that gives me something other than a dead machine
> with a glowing power-on light is forward progress.
> 
> Will give this patch a try today and report back.
> 
> At the moment am running the machine without either USB driver loaded.
> Just to see if they are contributing to the problems.

It looks like there's a serious problem in your UHCI hardware.  
According to the log you posted, it's not working at all.

Of course, that's no excuse for an oops.

Alan Stern

