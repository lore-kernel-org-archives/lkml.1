Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZCGC5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZCGC5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 21:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZCGC53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 21:57:29 -0500
Received: from kroah.org ([198.145.64.141]:35948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751021AbZCGC52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 21:57:28 -0500
Date: Fri, 6 Mar 2009 18:22:38 -0800
From: Greg KH <greg@kroah.com>
To: Martin Bammer <mrbm74@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: usb/host/pci-quirks: Add option for setting handoff timeout
	for ehci
Message-ID: <20090307022238.GA3596@kroah.com>
References: <1236340355.16732.23.camel@localhost> <20090306175036.GC3099@kroah.com> <1236367605.16732.47.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236367605.16732.47.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

On Fri, Mar 06, 2009 at 08:26:45PM +0100, Martin Bammer wrote:
> Yes right. It fails faster, because the bios doesn't handoff the device.

And that's bad.

> But it's no help for the user that he always has to wait 8s because of a
> buggy bios.

Complain to the manufacturer so they can fix the bios.

> Although the handoff fails the usb-controller works without any
> problems.

For some reason, I really don't believe that this would always be the
case :)

So sorry, we can't take this.

thanks,

greg k-h
