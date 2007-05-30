Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbXE3Ovb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbXE3Ovb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbXE3OvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:51:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50108 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751188AbXE3OvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:51:23 -0400
Date: Wed, 30 May 2007 10:51:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sending signals to a kernel thread, broken in 2.6.22
In-Reply-To: <1180528720.3976.42.camel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.44L0.0705301050080.2564-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Nigel Cunningham wrote:

> Hmm. Given Oleg's reply, it could pay to check that freezable kernel
> threads are still being frozen.

I don't think we have to worry about this.  See this discussion thread:

	http://marc.info/?t=118045713200006&r=1&w=2

and in particular this message:

	http://marc.info/?l=linux-kernel&m=118046964817995&w=2

Alan Stern

