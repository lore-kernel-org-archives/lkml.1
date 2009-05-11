Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbZEKU5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbZEKU5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbZEKU4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:56:52 -0400
Received: from kroah.org ([198.145.64.141]:36421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbZEKU4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:56:52 -0400
Date: Mon, 11 May 2009 12:28:27 -0700
From: Greg KH <greg@kroah.com>
To: Robert Mykland <robert@ascenium.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Vendor info from device name
Message-ID: <20090511192827.GA19776@kroah.com>
References: <4A04CB41.3040008@ascenium.com> <20090509043422.GA13794@kroah.com> <4A086CF8.3000503@ascenium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A086CF8.3000503@ascenium.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 11:22:48AM -0700, Robert Mykland wrote:
> <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

Please don't use html, the linux-kernel list will reject it.

> I want to do this in the kernel because I want to apply some particular
> file security measures to a specific device, but not to all devices
> with a vfat file system.

But you would do that from userspace right?

What block driver would be able to look into the file system contents?

> Thus a need to identify the device from the file system driver.

What driver needs this to be added to it?

thanks,

greg k-h
