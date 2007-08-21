Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbXHUMT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbXHUMT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbXHUMTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:19:20 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:60093 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750742AbXHUMTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:19:19 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with =?iso-8859-1?q?linux=09v2=2E6=2E23-rc3-50-g28e8351?=
Date: Tue, 21 Aug 2007 14:19:16 +0200
User-Agent: KMail/1.9.7
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Florin Iucha <florin@iucha.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <20070815133147.GA7124@iucha.net> <20070821115115.GD10422@iucha.net> <200708211406.31726.oliver@neukum.org>
In-Reply-To: <200708211406.31726.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708211419.16660.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 21 August 2007 schrieb Oliver Neukum:
> [   60.756730] usb 1-9: usb auto-resume
> Did you hit a key at that time?
> 
> 
> It looks like your keyboard gets autosuspended. But how can that happen?
> Keyboards should never autosuspend, as they are always open.
> The patch for minimum autosuspend support in HID did get in earlier,
> didn't it?
> 

Sorry disregard the question, I mistook your devices.

	Regards
		Oliver

