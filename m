Return-Path: <linux-kernel-owner+w=401wt.eu-S1030506AbXBTWXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506AbXBTWXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030505AbXBTWXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:23:25 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48271 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030506AbXBTWXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:23:24 -0500
Message-ID: <45DB74D9.206@garzik.org>
Date: Tue, 20 Feb 2007 17:23:21 -0500
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

Does performance come back if you also use acpi=off ?

	Jeff



