Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbXGIW21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbXGIW21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXGIW2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:28:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54016 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755094AbXGIW2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:28:19 -0400
Date: Mon, 9 Jul 2007 18:28:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Tejun Heo <htejun@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
In-Reply-To: <20070709172623.0c87aafd@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0707091827200.8799-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Cornelia Huck wrote:

> On Sun, 8 Jul 2007 10:31:21 -0400 (EDT),
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > There are some ways around this such as using a different workqueue, 
> > one that could safely be blocked during the suspend.
> 
> This would be the simplest solution, I think.

I have to agree.

Alan Stern

