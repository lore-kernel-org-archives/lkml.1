Return-Path: <linux-kernel-owner+w=401wt.eu-S965291AbXBTQGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965291AbXBTQGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965312AbXBTQGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:06:35 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44319 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965291AbXBTQGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:06:34 -0500
Message-ID: <45DB1C89.4040602@garzik.org>
Date: Tue, 20 Feb 2007 11:06:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/5] sata_nv: Add CPB register info to error_handler output
References: <45DA4887.1060705@shaw.ca>
In-Reply-To: <45DA4887.1060705@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> When error handling occurs with pending commands, output the contents
> of the next CPB count and next CPB index registers as well as the others,
> since these may be useful for debugging.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

applied 1-5.  Thanks for splitting it up.


