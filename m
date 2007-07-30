Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbXG3N7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbXG3N7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 09:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXG3N7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 09:59:38 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:41579 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764682AbXG3N7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 09:59:37 -0400
Date: Mon, 30 Jul 2007 09:57:39 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: 2.6.23-rc1, spamassassin vs rpc stuffs, rpc 1, spamassassin 0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200707300957.39667.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

As in something in the rpc daemons started at boot time grabbed localhost:783, 
which is SA's local port.  I had to kill fetchmail, get x working, edit the 
services to kill the rpc stuff and reboot before spamassassin would start.

As spamassassin (spamd) is pretty important, that didn't seem to be very nice.  
As I don't use NFS here, that's no great loss.

Comments anyone?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Is it clean in other dimensions?
