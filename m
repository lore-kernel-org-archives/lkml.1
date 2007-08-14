Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbXHNN4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbXHNN4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXHNN4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:56:39 -0400
Received: from aa014msr.fastwebnet.it ([85.18.95.74]:37818 "EHLO
	aa014msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbXHNN4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:56:38 -0400
Date: Tue, 14 Aug 2007 15:47:47 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] spontaneous disconnect with "usb-storage:
 implement autosuspend"
Message-ID: <20070814154747.6272ccf3@localhost>
In-Reply-To: <200708141530.28182.oliver@neukum.org>
References: <20070814131557.5653d991@localhost>
 <200708141530.28182.oliver@neukum.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007 15:30:27 +0200
Oliver Neukum <oliver@neukum.org> wrote:

> > my USB photo-camera gets automagically disconnected before I can do
> > anything with it ;)
> >   
> 
> hi,
> 
> I need vendor:product. Please provide "lsusb".
> Generally a bug report for a specific usb device without vendor:product
> is a bad idea.

oopss  :)


HP PHOTOSMART E317

tux ~ # lsusb
Bus 007 Device 001: ID 0000:0000
Bus 006 Device 002: ID 03f0:4002 Hewlett-Packard PhotoSmart 720 / PhotoSmart 935 (storage)
...

-- 
	Paolo Ornati
	Linux 2.6.23-rc3 on x86_64
