Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYLJPBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYLJPBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 10:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYLJPB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 10:01:29 -0500
Received: from senator.holtmann.net ([87.106.208.187]:37875 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbYLJPB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 10:01:28 -0500
Subject: Re: [PATCH] dynamic_printk: add line feed to printk
From: Marcel Holtmann <marcel@holtmann.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20081210144058.GA11842@localhost>
References: <20081210073347.GA18737@localhost>
	 <1228904326.19553.127.camel@violet.holtmann.net>
	 <20081210144058.GA11842@localhost>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 16:01:22 +0100
Message-Id: <1228921282.19553.153.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > Append '\n' to two printk messages.
> > 
> > I already sent a patch for that and Greg picked it up.
> 
> No I didn't find it in the usb-2.6 tree:

I don't know in detail how Greg manages its trees, but here is the patch

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver-core.current/driver-core-add-newlines-to-debugging-enabled-disabled-messages.patch

Regards

Marcel


