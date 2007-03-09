Return-Path: <linux-kernel-owner+w=401wt.eu-S1767245AbXCINCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767245AbXCINCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 08:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767246AbXCINCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 08:02:00 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55814 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767245AbXCINB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 08:01:59 -0500
Message-ID: <45F15AC4.7080600@garzik.org>
Date: Fri, 09 Mar 2007 08:01:56 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_cmd640: Multiple updates
References: <20070307164329.752993ff@lxorguk.ukuu.org.uk>
In-Reply-To: <20070307164329.752993ff@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Add suspend/resume support
> Write 0x5B to 0 not 0x5C
> 
> The former is important as we must kill the FIFO on a resume
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied


