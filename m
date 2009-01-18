Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbZARTXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbZARTXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 14:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZARTW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 14:22:57 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:43000 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbZARTW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 14:22:56 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2009 14:22:55 EST
From: Ondrej Zary <linux@rainbow-software.org>
To: Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.28.1
Date: Sun, 18 Jan 2009 20:16:03 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
References: <20090118185408.GC6478@kroah.com>
In-Reply-To: <20090118185408.GC6478@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901182016.07267.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2009 19:54:08 you wrote:
> We (the -stable team) are announcing the release of the 2.6.28.1
> kernel.
>
> It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
> series are strongly encouraged to upgrade.

I do not see any fix for the broken libusb: http://lkml.org/lkml/2009/1/2/47

libusb is not only broken on x86_64, but everywhere. My camera does not work 
with gphoto2 in 2.6.28 (I'm using x86). The patch linked above fixes the 
problem for me.

-- 
Ondrej Zary
