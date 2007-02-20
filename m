Return-Path: <linux-kernel-owner+w=401wt.eu-S1030505AbXBTWYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030505AbXBTWYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030507AbXBTWYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:24:00 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48282 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030505AbXBTWX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:23:58 -0500
Message-ID: <45DB74FC.2070102@garzik.org>
Date: Tue, 20 Feb 2007 17:23:56 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@mail.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [git patches] libata ACPI support
References: <20070220214716.GA3690@mail.muni.cz>
In-Reply-To: <20070220214716.GA3690@mail.muni.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Hello,
> 
> introducing SATA ACPI does not work for me (I've filled the bug
> report: http://bugzilla.kernel.org/show_bug.cgi?id=8046) beside those error
> messages, IDE performance is decreased. libata.noacpi=1 option works ok but
> the performance is still slightly degraded (about 10%).

Also, please add hardware info (full dmesg, full lspci) to the bug.

	Jeff



