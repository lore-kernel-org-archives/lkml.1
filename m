Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbXIZBK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbXIZBK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXIZBKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:10:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51402 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbXIZBKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:10:17 -0400
Message-ID: <46F9B174.8020806@garzik.org>
Date: Tue, 25 Sep 2007 21:10:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: "Berck E. Nash" <flyboy@gmail.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <fa.7B5oGGPZtkIAG9trDHdybt+z9Qg@ifi.uio.no> <fa.lh2GEsFivC+TeMBqgRXU+5p7ySM@ifi.uio.no> <fa.tqIC/0YXN2BDEJQ7WBFuJ0EEUrI@ifi.uio.no> <fa.Q/HeymU0u7VpG+dN5Lc1DraTos0@ifi.uio.no> <46F98E09.70805@shaw.ca>
In-Reply-To: <46F98E09.70805@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> ATA spec says "The device shall return command aborted if the device 
> does not support the Power Management feature set." Whereas TEST UNIT 
> READY is required for SCSI. It seems the SAT authors didn't consider 
> this case.


Dumb me -- I misread that as mandatory.

	Jeff


