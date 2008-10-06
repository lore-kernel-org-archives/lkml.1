Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbYJFUAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbYJFUAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYJFUAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:00:39 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:41820 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYJFUAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:00:38 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Reigo =?utf-8?q?K=C3=BCngas?= <reigo@itx.ee>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: PROBLEM: linksys USB1000linksys, asix driver (2.6.26.5)
Date: Mon, 6 Oct 2008 22:03:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0810062130180.23753@ares.softexpert.eu>
In-Reply-To: <Pine.LNX.4.64.0810062130180.23753@ares.softexpert.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810062203.39663.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 6. Oktober 2008 21:19:23 schrieb Reigo Küngas:
> Same behaiviour in 2 servers - one running 2.6.26 kernel and second 
> 2.6.26.5 kernel both has similar hardware and same usb gigabit network 
> adapter and similar problems.
> 
> dmesg output below - please let me know if you need more information.

Please recompile your kernel with CONFIG_USB_DEBUG and repost
dmesg only to the point it fails. Do not unload the driver. An additional
usbmon trace would also be helpful.

	Regards
		Oliver

