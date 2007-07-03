Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbXGCOQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbXGCOQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbXGCOQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:16:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60351 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbXGCOQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:16:18 -0400
Message-ID: <468A5A2E.1040701@garzik.org>
Date: Tue, 03 Jul 2007 10:16:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: CONFIG_PM=n compile fix
References: <20070527030954.GA18974@havoc.gtf.org> <20070603225840.GA25465@lixom.net>
In-Reply-To: <20070603225840.GA25465@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> CONFIG_PM=n compile fix.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> ---
> 
> Hi,
> 
> On Sat, May 26, 2007 at 11:09:54PM -0400, Jeff Garzik wrote:
> 
>> This is checked into the 'mv-ahci-pata' branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> 
> Didn't build for me without this change, since I had CONFIG_PM=n.

applied


