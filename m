Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbYHHWLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbYHHWLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbYHHVzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3229 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760334AbYHHVzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:55:21 -0400
Date: Fri, 8 Aug 2008 17:55:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jeff Garzik <jeff@garzik.org>
cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.27-rc] USB storage:  hangs and massive dmesg spews
In-Reply-To: <489CBC49.6050602@garzik.org>
Message-ID: <Pine.LNX.4.44L0.0808081753500.24293-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, Jeff Garzik wrote:

> 4) a huge amount of dmesg spew followed.  at the time of this writing, 
> the following spew has been passed to dmesg over TWO HUNDRED times:

> It is completely silly to fill my dmesg buffer many times over, with the 
> same basic information.  /proc/sys/kernel/hung_task_timeout_secs is 
> completely irrelevant here, you need spew limiting in addition to fixing 
> the USB storage hang problem.

Sorry, I meant to say earlier that the usb-storage problem is fixed in 
-rc2.  I can't speak for the "spew" issue; that's somebody else's 
department.  :-)

Alan Stern

