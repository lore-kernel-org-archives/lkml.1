Return-Path: <linux-kernel-owner+w=401wt.eu-S1030243AbXBTQj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030243AbXBTQj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030238AbXBTQj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:39:59 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44852 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030243AbXBTQj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:39:58 -0500
Message-ID: <45DB245C.8010504@garzik.org>
Date: Tue, 20 Feb 2007 11:39:56 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] pata: Display Configuring .. lines for devices with private
 set_mode methods
References: <20070220173543.096963d5@localhost.localdomain>
In-Reply-To: <20070220173543.096963d5@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> We can't specify which mode in the cases below but we can at least say
> PIO and look consistent with the default.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied


