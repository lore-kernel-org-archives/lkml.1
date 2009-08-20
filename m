Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZHTTel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZHTTel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZHTTek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:34:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35544 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752117AbZHTTek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:34:40 -0400
Date: Thu, 20 Aug 2009 15:34:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] TTY: fix typos
In-Reply-To: <20090820192915.GB15574@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0908201533540.2670-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009, Greg KH wrote:

> On Thu, Aug 20, 2009 at 03:23:47PM -0400, Alan Stern wrote:
> > This patch (as1282) fixes some obvious typos in the TTY core.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> Ick, this looks like it needs to go in for .31, right?

No, these are typos in the new code queued for .32.  2.6.31 looks all 
right.

Alan Stern

