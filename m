Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbXHUMJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbXHUMJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXHUMJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:09:11 -0400
Received: from twin.jikos.cz ([213.151.79.26]:40224 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbXHUMJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:09:10 -0400
Date: Tue, 21 Aug 2007 14:09:00 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Oliver Neukum <oliver@neukum.org>
cc: linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Florin Iucha <florin@iucha.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with
 =?utf-8?q?linux=09v2=2E6=2E23-rc3-50-g28e8351?=
In-Reply-To: <200708211406.31726.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0708211407370.2460@twin.jikos.cz>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz>
 <20070821115115.GD10422@iucha.net> <200708211406.31726.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Oliver Neukum wrote:

> It looks like your keyboard gets autosuspended. But how can that happen? 
> Keyboards should never autosuspend, as they are always open. The patch 
> for minimum autosuspend support in HID did get in earlier, didn't it?

Hi Oliver,

it actually even is not in mainline, it's queued in my tree for the next 
merge window.

-- 
Jiri Kosina
