Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbXJWUmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbXJWUmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXJWUmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:42:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43539 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbXJWUmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:42:11 -0400
Message-ID: <471E5C9E.3020509@garzik.org>
Date: Tue, 23 Oct 2007 16:42:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: mark irqbalance not-recommended
References: <20071023115709.GA1734@elf.ucw.cz>
In-Reply-To: <20071023115709.GA1734@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Mark CONFIG_IRQBALANCE as not recommended any more. It eats too much
> power, and better solutions are available in userspace.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

ACK


