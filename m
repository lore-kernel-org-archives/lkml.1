Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbYGZSom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbYGZSom (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYGZSoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:44:34 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55653 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYGZSod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:44:33 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Alfred E. Heggestad" <aeh@db.org>
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset #2
Date: Sat, 26 Jul 2008 20:45:21 +0200
User-Agent: KMail/1.9.9
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200806271424.50425.oliver@neukum.org> <20080725141420.GA29395@anvil.corenet.prv> <488B48F7.5060002@db.org>
In-Reply-To: <488B48F7.5060002@db.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807262045.22722.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 26 Juli 2008 17:55:35 schrieb Alfred E. Heggestad:
> Jul 26 17:32:33 io kernel: hald-addon-keyb[23629]: segfault at 6f6f6c5f ip b7e9855b sp bf9d89dc error 4 in libc-2.6.1.so[b7e28000+144000]
> Jul 26 17:32:43 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22
> Jul 26 17:33:21 io last message repeated 6 times
> Jul 26 17:34:28 io last message repeated 17 times

This should not happen. Please provide more context. If possible
recompile your kernel with CONFIG_USB_DEBUG.

	Regards
		Oliver

