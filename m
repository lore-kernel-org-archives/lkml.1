Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbYHQEVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbYHQEVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 00:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbYHQEVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 00:21:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47933 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYHQEVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 00:21:07 -0400
Message-ID: <48A7A727.1030300@garzik.org>
Date: Sun, 17 Aug 2008 00:20:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mikael Pettersson <mikpe@it.uu.se>, Grant Coady <gcoady.lk@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ATA Kconfig cleanup: hide ATA_SFF and add SATA/PATA
 menu items
References: <qjoca411hv4hm25keq70ul5pnbi7747d13@4ax.com>	<18598.42334.73411.476062@harpo.it.uu.se> <20080816113224.5562a9a6@lxorguk.ukuu.org.uk>
In-Reply-To: <20080816113224.5562a9a6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I suspect sata_via will want this too.
> 
> Lust about any PATA chip may be on boards with SATA bridges so the divide
> doesn't really work.

That's my reason for why the patches like this tend to be uninteresting...

	Jeff



