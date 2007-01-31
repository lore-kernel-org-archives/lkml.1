Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbXAaLu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbXAaLu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXAaLu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:50:26 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56105 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086AbXAaLuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:50:25 -0500
Message-ID: <45C0827C.2050207@garzik.org>
Date: Wed, 31 Jan 2007 06:50:20 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/7] devres: device resource management
References: <11692764264005-git-send-email-htejun@gmail.com>
In-Reply-To: <11692764264005-git-send-email-htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Implement device resource management, in short, devres.  A device

ACK patches 1-7.  Applied patches 1-6 (with some remaining pata_platform 
damage) to #upstream.

Please examine the resulting damage, and resend patch #7, plus any 
missing bits

	Jeff



