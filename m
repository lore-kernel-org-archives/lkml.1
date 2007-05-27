Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbXE0MDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbXE0MDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 08:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXE0MD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 08:03:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37437 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbXE0MD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 08:03:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46597380.8010107@s5r6.in-berlin.de>
Date: Sun, 27 May 2007 14:03:12 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Kristian Hoegsberg <krh@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] firewire: fix return code
References: <20070527110918.GA11367@havoc.gtf.org>
In-Reply-To: <20070527110918.GA11367@havoc.gtf.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Fix this warning on x86-64
> 
> drivers/firewire/fw-cdev.c:798: warning: initialization from incompatible pointer type

Committed to linux1394-2.6.git, will include it in the next batch of
updates for Linus.  Thanks,
-- 
Stefan Richter
-=====-=-=== -=-= ==-==
http://arcgraph.de/sr/
