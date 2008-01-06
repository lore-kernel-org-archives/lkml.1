Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYAFU4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYAFU4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 15:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYAFU4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 15:56:04 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:58216 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYAFU4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 15:56:03 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [FEATURE REQUEST] Transparent hot plugging of root file system on portable storage devices.
Date: Sun, 6 Jan 2008 21:59:45 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Raymano Garibaldi <raymano@faunos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
References: <Pine.LNX.4.44L0.0801061213460.8070-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801061213460.8070-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801062159.46481.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 06 Januar 2008 schrieb Alan Stern:
> What about people who want to suspend to RAM instead of hibernating and
> _do_ want to unplug the USB device containing their root filesystem
> while the machine is asleep?  In this case we will _know_ that the
> power session has been interrupted, but USB Persist won't activate
> because the host controller never lost power.

Would it be hard to force the persist feature on for a replugged device?

	Regards
		Oliver

