Return-Path: <linux-kernel-owner+w=401wt.eu-S1763965AbYHHW3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763965AbYHHW3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYHHW3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:29:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44996 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbYHHW3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:29:41 -0400
Message-ID: <489CC8D2.2010006@garzik.org>
Date: Fri, 08 Aug 2008 18:29:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.27-rc] USB storage:  hangs and massive dmesg spews
References: <Pine.LNX.4.44L0.0808081752270.24293-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808081752270.24293-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Fri, 8 Aug 2008, Jeff Garzik wrote:
>> 3) judging from ls(1), the entire storage device's contents was 
>> successfully dumped to my hard drive.  HOWEVER, dd(1) sat in disk wait, 
>> failing to end execution once the end of the USB storage device was reached.

> This has been fixed in 2.6.27-rc2.

Awesome, thanks!

	Jeff


