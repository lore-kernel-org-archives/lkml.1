Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYBSQua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYBSQua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYBSQuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:50:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52741 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbYBSQuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:50:22 -0500
Message-ID: <47BB08C3.4070807@garzik.org>
Date: Tue, 19 Feb 2008 11:50:11 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] AMD opteron mm config numa etc
References: <200802190319.28699.yinghai.lu@sun.com>
In-Reply-To: <200802190319.28699.yinghai.lu@sun.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> please check some amd opteron related mmconf and numa patches
> 
> could make up for system that system have acpi problem
> or still can mmconf and numa when acpi=off

ACK for my parts (stuff associated with PCI domain support on x86)

	Jeff




