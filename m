Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbXKJXgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbXKJXgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 18:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbXKJXf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 18:35:56 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37895 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994AbXKJXfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 18:35:55 -0500
Message-ID: <47364059.8000003@garzik.org>
Date: Sat, 10 Nov 2007 18:35:53 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Will Trives <will@trivescon.com.au>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: cd/dvd inaccessible in 2.6.24-rc2
References: <1194668831.3436.14.camel@Athas>
In-Reply-To: <1194668831.3436.14.camel@Athas>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will Trives wrote:
> Hello,
> 
> Motherboard: Gigabyte GA-P35-DS4 (rev. 1.1)
> Chipset: Intel P35 + ICH9R 
> PATA port runs off JMicron controller
> CD/DVD Device: BENQ DW1640 16X
> 
> I cannot access my dvd burner under 2.6.24-rc2, I have no problems under
> 2.6.23. Basically the drive is detected OK, everything looks ok but as
> soon as I go to use it errors like this occur:

Is 2.6.24-rc1 also broken?

	Jeff



