Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbXJ3Tdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbXJ3Tdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbXJ3TbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:31:06 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:45836 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbXJ3TbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:31:04 -0400
Message-ID: <47278674.3050009@s5r6.in-berlin.de>
Date: Tue, 30 Oct 2007 20:31:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: add filter function to groups
References: <1193671019.3383.13.camel@localhost.localdomain>	 <1193676852.2655.21.camel@lov.site>	 <1193677071.3383.56.camel@localhost.localdomain>	 <47261F50.3050901@s5r6.in-berlin.de> <1193768743.3321.91.camel@localhost.localdomain>
In-Reply-To: <1193768743.3321.91.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> OK, so is this latest revision acceptable to everyone?

No complaint from me.  (I'm more or less by accident in this thread
anyway.  Once this feature is available in mainline, I may have use for
it in drivers/firewire/ though.)  Thanks,
-- 
Stefan Richter
-=====-=-=== =-=- ====-
http://arcgraph.de/sr/
