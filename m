Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbYDAVEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbYDAVEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761211AbYDAVCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:02:38 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3884 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761198AbYDAVCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:02:37 -0400
Date: Tue, 1 Apr 2008 17:02:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Pavel Machek <pavel@ucw.cz>, <linux-usb@vger.kernel.org>,
       Soeren Sonnenburg <sonne@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core
 Duo
In-Reply-To: <20080401202557.GA6617@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0804011701340.9362-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Tino Keitel wrote:

> On Tue, Apr 01, 2008 at 15:06:51 -0400, Alan Stern wrote:
> 
> [...]
> 
> > Can you get any information out of the computer after the hang?  It 
> > would help to see the dmesg log (with CONFIG_USB_DEBUG enabled) and an 
> > Alt-SysRq-T stack dump.
> 
> Looks difficult. The text console stays black after resume, and there
> is no serial interface.

Network console?  SSH?  Or even telnet?

Alan Stern

