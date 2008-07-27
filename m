Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYG0GXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYG0GXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYG0GX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:23:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:47302 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYG0GX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:23:27 -0400
Date: Sat, 26 Jul 2008 22:54:20 -0700
From: Greg KH <greg@kroah.com>
To: stephane ancelot <sancelot@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: usb port share
Message-ID: <20080727055420.GA29457@kroah.com>
References: <op.ueqix5a2nuwxn3@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ueqix5a2nuwxn3@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 09:55:07AM +0200, stephane ancelot wrote:
> Hi,
> I would like to know if it is already possible to share a usb port ?

A single port?  If you want to do that, plug a hub into it.

> I would need it in order designing a usb over ip interface.

What's wrong with the existing usb over ip code for Linux?

thanks,

greg k-h
