Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZDHFR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZDHFR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZDHFRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:17:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38375 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbZDHFRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:17:15 -0400
Message-ID: <49DC3357.3030703@garzik.org>
Date: Wed, 08 Apr 2009 01:17:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sagar Borikar <sagar.borikar@gmail.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, d.harrison@sutus.com
Subject: Re: [PATCH 2/2] sata_sil: disable DMA engine in ->freeze
References: <20090407232247.GA16086@havoc.gtf.org>	 <20090407232331.GA16190@havoc.gtf.org> <3fb94e50904072213n637525b1w4b032544dcef3618@mail.gmail.com>
In-Reply-To: <3fb94e50904072213n637525b1w4b032544dcef3618@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sagar Borikar wrote:
> This patch works for our platform.

Did you try both patches together?  Both are required for the solution.

	Jeff



