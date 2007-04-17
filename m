Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXDQV2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXDQV2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXDQV2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:28:39 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56156
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXDQV2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:28:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Greg KH <gregkh@suse.de>
Subject: Prolific PL2303/05 driver
Date: Tue, 17 Apr 2007 23:27:43 +0200
User-Agent: KMail/1.9.5
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704172327.43170.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

looking through the pl2303 driver, it seems you know about
the internals.

So I'm contacting you to ask if you got specification for this device.
I have got a pl2305 (usb to parport) device and it seems there's no
driver for it. On the Prolific page there is a datasheet download,
but it seems to be incomplete.
It seems that I could get basic functionality to work with it, but
it seems to be missing a lot.
Any suggestion on where to get proper specs for this device?

Or do you even know where a driver is hidden? :)

-- 
Greetings Michael.
