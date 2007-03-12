Return-Path: <linux-kernel-owner+w=401wt.eu-S1030587AbXCLQ2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030587AbXCLQ2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030603AbXCLQ2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:28:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:52146 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030587AbXCLQ2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:28:53 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
Date: Mon, 12 Mar 2007 17:28:44 +0100
User-Agent: KMail/1.9.1
Cc: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45F579CF.7040802@rtr.ca> <45F57BB8.5010705@rtr.ca>
In-Reply-To: <45F57BB8.5010705@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703121728.45314.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. März 2007 17:11 schrieb Mark Lord:
> Mark Lord wrote:
> > Greg KH wrote:
> >> Does userspace have it open when you suspend/resume?
> > 
> > For the ooops I just posted, yes, I may have left Linux ckermit
> > running on the serial port before the suspend.
> 
> Here's a retest under linux-2.6.21-rc3-git7,
> doing suspend/resume (RAM) with ckermit open on the serial port.

I am looking at it.

	Regards
		Oliver
