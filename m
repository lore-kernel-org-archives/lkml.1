Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbZHCVVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbZHCVVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZHCVVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:21:30 -0400
Received: from kroah.org ([198.145.64.141]:38188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbZHCVVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:21:30 -0400
Date: Mon, 3 Aug 2009 14:20:15 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
Subject: Re: Is anyone maintaining (or even using) usbtmc?
Message-ID: <20090803212015.GC28579@kroah.com>
References: <cb0375e10908031414g471bacf5lab685958b60bfdfa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0375e10908031414g471bacf5lab685958b60bfdfa@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 05:14:56PM -0400, Andrew Lutomirski wrote:
> Hi all-
> 
> I'm trying to use usbtmc on an Aglient N9310A (The only TMC device I
> have), and it sort of works, but it seems to be both extremely buggy
> and missing a good deal of rather important functionality.  Is there
> anyone maintaining it?

Yes, me.

> If the answer is yes, I can describe the bugs (logspam, spurious
> errors, delayed messages, inability to read status, etc.) in greater
> detail.

Please do, but also please use the latest version, in 2.6.30.3, we fixed
some bad problems in it recently.

> Is anyone using usbtmc, or, more specifically, does anyone care about
> backward compatibility?

What do you want to change in the driver interface?

thanks,

greg k-h
