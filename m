Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYAATcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYAATcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 14:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYAATcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 14:32:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36642 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbYAATcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 14:32:12 -0500
Date: Tue, 1 Jan 2008 20:29:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Raymano Garibaldi <raymano@faunos.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [FEATURE REQUEST] Transparent hot plugging of root file system on portable storage devices.
Message-ID: <20080101202945.GA14190@ucw.cz>
References: <1618816c0711261104m3177a2bas24446035557f9593@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618816c0711261104m3177a2bas24446035557f9593@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi1

> I would like to request a feature in the Linux kernel that would allow
> a user to unplug a live read-only root file system which exists on a
> detachable storage device such as a USB key drive. The desired
> behavior is that once the same device is reattached to the computer
> the user can continue work transparently without having to reboot.
> 
> Having such a feature is becoming more important with advances in
> detachable solid state drive technology.

Yep, that would be nice.... In fact, patch would be very welcome :-).


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
