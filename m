Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYCNPCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYCNPCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 11:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYCNPCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 11:02:41 -0400
Received: from eazy.amigager.de ([213.239.192.238]:36766 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYCNPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 11:02:40 -0400
Date: Fri, 14 Mar 2008 16:02:38 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: broken access to a USB HID device after suspend
Message-ID: <20080314150238.GB16182@eazy.amigager.de>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <20080314071336.GA14550@dose.home.local> <Pine.LNX.4.44L0.0803141020190.4478-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803141020190.4478-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 10:34:06 -0400, Alan Stern wrote:

[...]

> When you get these errors, do you exit from the hidmon program and 
> restart it?  Do the errors still occur after restarting?

Hidmon is a simple commandline application, something like hdparm for
LCD's. So, yes, I restarted it multiple times.

Regards,
Tino
