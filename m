Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbYDAUZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbYDAUZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbYDAUZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:25:15 -0400
Received: from eazy.amigager.de ([213.239.192.238]:38613 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879AbYDAUZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:25:14 -0400
Date: Tue, 1 Apr 2008 22:25:57 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, linux-usb@vger.kernel.org,
       Soeren Sonnenburg <sonne@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
	Core Duo
Message-ID: <20080401202557.GA6617@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Pavel Machek <pavel@ucw.cz>, linux-usb@vger.kernel.org,
	Soeren Sonnenburg <sonne@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <20080401183732.GA5043@dose.home.local> <Pine.LNX.4.44L0.0804011505050.1397-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0804011505050.1397-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 15:06:51 -0400, Alan Stern wrote:

[...]

> Can you get any information out of the computer after the hang?  It 
> would help to see the dmesg log (with CONFIG_USB_DEBUG enabled) and an 
> Alt-SysRq-T stack dump.

Looks difficult. The text console stays black after resume, and there
is no serial interface.

Regards,
Tino
