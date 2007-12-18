Return-Path: <linux-kernel-owner+w=401wt.eu-S937124AbXLRBoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937124AbXLRBoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762575AbXLRBiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:38:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60158 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762903AbXLRBiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:38:16 -0500
Message-ID: <4767246C.3000407@pobox.com>
Date: Mon, 17 Dec 2007 20:37:48 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Tejun Heo <htejun@gmail.com>, hp@syntomax.com, Alan Cox <alan@redhat.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_mv: improve warnings about Highpoint RocketRAID
 23xx cards
References: <475ECFAD.2030901@rtr.ca>
In-Reply-To: <475ECFAD.2030901@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Improve the existing boot/load time warnings from sata_mv
> for Highpoint RocketRAID 23xx cards, based on new knowledge
> about where the BIOS likes to overwrite sectors with metadata.
> 
> Harmless to us, but very useful for end users.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> ---
> This should ideally go upstream for 2.6.24.

applied #upstream-fixes


