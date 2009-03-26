Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbZCZWlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbZCZWlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZCZWk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:40:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38761 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbZCZWkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:40:55 -0400
Message-ID: <49CC046A.7040209@garzik.org>
Date: Thu, 26 Mar 2009 18:40:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parport: Use the PCI IRQ if offered
References: <20090326205558.5686.36265.stgit@localhost.localdomain>
In-Reply-To: <20090326205558.5686.36265.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

Reviewed-by: Jeff Garzik <jgarzik@redhat.com>

A long, long time ago I poked at introducing some PCI-ish probing to 
parport_pc, reading the port mode, I/O port, and possibly irq from 
motherboard-specific magic locations.

This is a helpful extension of that [years-old] work... good stuff.

	Jeff



