Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbXJJBJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbXJJBJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 21:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbXJJBJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 21:09:36 -0400
Received: from gw.goop.org ([64.81.55.164]:43141 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbXJJBJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 21:09:34 -0400
Message-ID: <470C2622.2080806@goop.org>
Date: Tue, 09 Oct 2007 18:08:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: NetDev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>,
       Stephen Hemminger <shemminge@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xen-netfront: rearrange netfront_info structure to separate
 tx and rx
References: <470BCC1D.4080007@goop.org> <470C20E9.9050405@garzik.org>
In-Reply-To: <470C20E9.9050405@garzik.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> ACK but does not apply to jgarzik/netdev-2.6.git#upstream nor
> davem/net-2.6.24.git 

OK, looks like you don't have the other two patches.  Will post in a sec.

    J
