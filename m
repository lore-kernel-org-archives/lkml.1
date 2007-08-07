Return-Path: <linux-kernel-owner+w=401wt.eu-S934385AbXHGUn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934385AbXHGUn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbXHGUnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:43:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54059 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576AbXHGUnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:43:50 -0400
Message-ID: <46B8D984.7040602@garzik.org>
Date: Tue, 07 Aug 2007 16:43:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@insightbb.com>
Subject: Re: 2.6.22: pcspkr driver no longer loads automatically
References: <46B8C8FA.9020100@redhat.com>
In-Reply-To: <46B8C8FA.9020100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> With no other changes but a kernel upgrade, the pcspkr driver
> doesn't load automatically anymore. No changes to that driver
> jump out, so where else could the problem be? Something to
> do with the device class changes maybe?

This has long been a problem for me on Fedora, long before 2.6.22.  I 
would never ever have the glorious system beeps, unless I built the 
module into my kernel.

I would look into distro areas and see why it's not getting loaded.

	Jeff



