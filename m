Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbXIGXrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbXIGXrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbXIGXrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:47:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57848 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbXIGXrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:47:07 -0400
Message-ID: <46E1E2F6.5060307@garzik.org>
Date: Fri, 07 Sep 2007 19:47:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>, n <xellos@bluebottle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: limiting to UDMA/33 instead of UDMA/100 - pata_pdc202xx_old (also
 XFS error)?
References: <007d01c7eaf6$74b9b350$0100a8c0@hak> <20070907130212.GI995458@sgi.com>
In-Reply-To: <20070907130212.GI995458@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
>>         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
>>         res 51/84:00:21:9d:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)


ATA bus error == straight-from-hardware reported error

Cable or connector is dying maybe?  Bad power supplies also sometimes 
manifest this way.

	Jeff


