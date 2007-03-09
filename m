Return-Path: <linux-kernel-owner+w=401wt.eu-S1767372AbXCIQds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767372AbXCIQds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767375AbXCIQds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:33:48 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57580 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767372AbXCIQdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:33:47 -0500
Message-ID: <45F18C69.2040904@garzik.org>
Date: Fri, 09 Mar 2007 11:33:45 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2.6.22] remove Intel combined mode quirk
References: <20070309160127.GA10226@havoc.gtf.org> <20070309172947.79ef61bf@lxorguk.ukuu.org.uk>
In-Reply-To: <20070309172947.79ef61bf@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> Acked-by: Alan Cox <alan@redhat.com>
> 
> and you can remove even more code as pci_request_resources() will now
> just do the right thing for all cases.

pci_request_regions() you mean?

	Jeff



