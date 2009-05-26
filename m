Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZEZQxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZEZQxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZEZQxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:53:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45304 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbZEZQxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:53:37 -0400
Date: Tue, 26 May 2009 19:52:40 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
Message-ID: <20090526165240.GE9842@redhat.com>
References: <20090526160343.GA9842@redhat.com> <Pine.LNX.4.44L0.0905261248430.9278-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905261248430.9278-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 12:51:35PM -0400, Alan Stern wrote:
> It looks exactly the same as this (this was taken from 
> 2.6.30-rc6).  Look starting at line 844 of drivers/scsi/scsi_lib.c.
> 
> Alan Stern

Yep, sorry.

-- 
MST
