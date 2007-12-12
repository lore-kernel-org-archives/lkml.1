Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbXLLERl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbXLLERl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXLLERc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:17:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43267 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbXLLERb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:17:31 -0500
Message-ID: <475F60D8.5060903@garzik.org>
Date: Tue, 11 Dec 2007 23:17:28 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Orion Poplawski <orion@cora.nwra.com>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata_mv hotplug flaky?
References: <fjn8j2$mji$1@ger.gmane.org>
In-Reply-To: <fjn8j2$mji$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Orion Poplawski wrote:
> Not sure what the latest status of sata_mv hotplug should be, but it 
> seems close.  I'm currently running 2.6.24-0.81.rc4.git7.fc9 with a 
> MV88SX5081.  Pulled a couple drives and re-added.  One device got 
> re-added, but the other did not.  It seems like I got the system to 
> probe and re-add the first drive by doing a "mount -a", but haven't been 
> able (no idea how) to re-add the second.
> 

hotplug made great strides with the introduction of the new-EH code, but 
it still needs a bit of work.  Mark Lord was looking into that, so you 
can sure your report has been noted...

	Jeff



