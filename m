Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZAKWTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZAKWTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbZAKWTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:19:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34336
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbZAKWTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:19:34 -0500
Date: Sun, 11 Jan 2009 14:19:35 -0800 (PST)
Message-Id: <20090111.141935.34892950.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: Valdis.Kletnieks@vt.edu, alessandro.suardi@gmail.com,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1231712154.25018.672.camel@macbook.infradead.org>
References: <1231676698.25018.147.camel@macbook.infradead.org>
	<20090111.133929.57600645.davem@davemloft.net>
	<1231712154.25018.672.camel@macbook.infradead.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Sun, 11 Jan 2009 22:15:54 +0000

> On Sun, 2009-01-11 at 13:39 -0800, David Miller wrote:
> > 
> > For example, for mounting an NFS root using that device.... Oh, will I
> > need an initramfs for that once you pull the firmware-in-kernel
> > option?
> 
> Of course, we've been talking for ages about pulling the dhcp and
> nfsroot hacks from the kernel and requiring an initrd for that _anyway_,
> but that's a different issue...

It's not there now, so in the mean time....
