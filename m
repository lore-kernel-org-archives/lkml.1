Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbXJ1SlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbXJ1SlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXJ1SlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:41:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60057 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbXJ1SlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:41:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: WANTED: kernel projects for CS students
Date: Sun, 28 Oct 2007 19:57:53 +0100
User-Agent: KMail/1.9.5
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071028180707.GA6111@ucw.cz>
In-Reply-To: <20071028180707.GA6111@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710281957.53914.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 28 October 2007 19:07, Pavel Machek wrote:
> Hi!
> 
> > - Are large enough to qualify as a student project, luckily there is
> >   flexibility here since we get inquiries for anything from 6 week
> >   projects to 6 month projects.
> > 
> > If you have ideas on what projects would be useful, please add them
> > to this page (or email me):
> 
> Hard stuff:
> 
> * network character device -- similar to nbd, but for char devices.
>   either figure out how to forward ioctls(), or implement
>   usb-over-network, or...
> 
> * openMosix -- they seem to have userspace solution, but not GPLed.

The project is no longer being developed, AFAICS.

> * compression for ext4. Its about time someone did it right. Special
>   bonus if you can do it in a way that it does not slow down. If cpu
>   is free, compress, if it is busy, just write it straight to disk.
