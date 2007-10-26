Return-Path: <linux-kernel-owner+w=401wt.eu-S1751757AbXJZWmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbXJZWmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXJZWlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:41:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34620 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbXJZWlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:41:44 -0400
Message-ID: <47226D23.90604@garzik.org>
Date: Fri, 26 Oct 2007 18:41:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       akpm@linux-foundation.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH v2] ISDN/capidrv: address two longstanding warnings
References: <20071026164357.GA5898@pingi.kke.suse.de>
In-Reply-To: <20071026164357.GA5898@pingi.kke.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Keil wrote:
> * change #warning to a code comment
> 
> * add comment and special ifdef'd 64-bit code for a situation where
>   we must store a pointer into a CAPI field 'Data', which is fixed by
>   the interface at 32 bits.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> Acked-by: Karsten Keil <kkeil@suse.de>

thanks!


