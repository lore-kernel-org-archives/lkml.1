Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbXDQO5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbXDQO5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbXDQO5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:57:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39892 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328AbXDQO5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:57:39 -0400
Message-ID: <4624E058.8010808@garzik.org>
Date: Tue, 17 Apr 2007 10:57:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       torresmat@gmail.com, conke.hu@gmail.com
Subject: Re: [PATCH] pci-quirks: disable MSI on RS400-200 and RS480
References: <20070416045918.GI10619@htj.dyndns.org>
In-Reply-To: <20070416045918.GI10619@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> MSI doesn't work on RS400-200 and RS480 requiring pci=nomsi kernel
> boot parameter for ahci to work.  This patch disables MSI on those
> chips.
> 
>   http://thread.gmane.org/gmane.linux.ide/17820
>   http://thread.gmane.org/gmane.linux.ide/17516
>   https://bugzilla.novell.com/show_bug.cgi?id=263893
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

ACK.  Greg will apply, I presume?


