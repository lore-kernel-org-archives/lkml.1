Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbXA1Rq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbXA1Rq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbXA1Rq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:46:57 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:28575 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbXA1Rq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:46:56 -0500
Date: Sun, 28 Jan 2007 09:42:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [patch] use __u32 rather than u32 in userspace ioctls in
 usbdevice_fs.h
Message-Id: <20070128094252.bc19261a.randy.dunlap@oracle.com>
In-Reply-To: <200701280723.57741.vapier@gentoo.org>
References: <200701280723.57741.vapier@gentoo.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007 07:23:57 -0500 Mike Frysinger wrote:

> the trivial attached patch fixes ioctl defines in usbdevice_fs.h that are 
> exported to userspace to use __u32 rather than u32

Hi Mike,

Have you now audited all ioctls (and sent patches) for this misbehavior?

---
~Randy
