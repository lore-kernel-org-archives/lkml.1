Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYLNPEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYLNPEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 10:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYLNPD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 10:03:59 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35006 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbYLNPD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 10:03:59 -0500
Message-ID: <4945205A.30802@garzik.org>
Date: Sun, 14 Dec 2008 10:03:54 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Thanasis <thanasis@asyr.hopto.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: SiI 3112 support in kernel 2.6.27
References: <49451B63.9040400@asyr.hopto.org>
In-Reply-To: <49451B63.9040400@asyr.hopto.org>
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis wrote:
> Q: In order to support the SiI 3112 (PCMCIA) controller, what module (or 
> built in option) should be set for kernel version 2.6.27?

sata_sil (CONFIG_SATA_SIL)

Regards,

	Jeff




