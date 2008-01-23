Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYAWWJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYAWWJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbYAWWH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:07:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787AbYAWWHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:07:21 -0500
Date: Wed, 23 Jan 2008 14:06:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: davem@davemloft.net, hidave.darkstar@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       cornelia.huck@de.ibm.com, gombasg@sztaki.hu, htejun@gmail.com,
       viro@zeniv.linux.org.uk, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] bluetooth : move children of connection device to NULL
 before connection down
Message-Id: <20080123140629.c24d4d68.akpm@linux-foundation.org>
In-Reply-To: <1200982696.7978.148.camel@aeonflux>
References: <20080121044913.GA4162@darkstar.te-china.tietoenator.com>
	<20080121045401.GB4162@darkstar.te-china.tietoenator.com>
	<20080121.031417.171098597.davem@davemloft.net>
	<1200982696.7978.148.camel@aeonflux>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Jan 2008 07:18:16 +0100 Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dave,
> 
> > > Add people missed in cc-list.
> > 
> > Thanks Dave for your continued efforts on Bluetooth bugs like this.
> > 
> > Marcel, are you going to review/ACK/integrate/push-upstream/whatever
> > any of these Bluetooth patches?
> > 
> > It hasn't been getting much love from you as of late, you are one of
> > the listed maintainers, and I don't want to lose any of Dave's
> > valuable bug fixing work.
> 
> I will be fully back in business next week. Just got stuck in a project
> that needed 200% of my time to get it going.
>

These patches in -mm:

bluetooth-hidp_process_hid_control-remove-unnecessary-parameter-dealing.patch
bluetooth-uninlining.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
bluetooth-blacklist-another-broadcom-bcm2035-device.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
hci_ldisc-fix-null-pointer-deref.patch

could benefit from some attention please.
