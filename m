Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbZEYTvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbZEYTvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZEYTvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:51:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47091 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZEYTvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:51:45 -0400
Date: Mon, 25 May 2009 22:50:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
Message-ID: <20090525195045.GA6768@redhat.com>
References: <87y6slb7ug.fsf@devron.myhome.or.jp> <Pine.LNX.4.44L0.0905251127410.23874-100000@netrider.rowland.org> <20090525184816.GB6649@redhat.com> <ac3eb2510905251232t3f0c5029tb006f72c9ab6ef8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510905251232t3f0c5029tb006f72c9ab6ef8e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 09:32:27PM +0200, Kay Sievers wrote:
> On Mon, May 25, 2009 at 20:48, Michael S. Tsirkin <mst@redhat.com> wrote:
> 
> >> > > Dev sdb: unable to read RDB block 0
> 
> Is this Fedora? Or are you running a recent version of DeviceKit-disks?
> 
> We've seen such problems when trying to issue SAT commands to some USB
> devices. If it's Fedora, this is fixed with an update to Fedora 11.
> 
> Kay

This is 2.6.30-rc6 from kernel.org.

-- 
MST
