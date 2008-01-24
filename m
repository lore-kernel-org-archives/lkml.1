Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYAXT5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYAXT5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYAXT53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:57:29 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:53445 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYAXT52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:57:28 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Date: Thu, 24 Jan 2008 21:00:21 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Wilco Beekhuizen <wilcobeekhuizen@gmail.com>,
       linux-kernel@vger.kernel.org
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com> <84144f020801240942y1c75c82geddc250b7e7814ac@mail.gmail.com> <20080124180313.GA16006@kroah.com>
In-Reply-To: <20080124180313.GA16006@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801242100.22090.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 24. Januar 2008 19:03:13 schrieb Greg KH:
> And the unplug issue at a filesystem level should be pretty trivial to
> handle, we do it all the time in /proc and /sys and other virtual
> filesystems (usbfs) with no problems.

A discussion about lifetime rules for objects in sysfs anyone? ;->

	Regards
		Oliver

