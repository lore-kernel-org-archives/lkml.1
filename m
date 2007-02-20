Return-Path: <linux-kernel-owner+w=401wt.eu-S965223AbXBTQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223AbXBTQCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965234AbXBTQCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:02:52 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44219 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965223AbXBTQCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:02:51 -0500
Message-ID: <45DB1BA9.20501@garzik.org>
Date: Tue, 20 Feb 2007 11:02:49 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Allen Martin <AMartin@nvidia.com>
Subject: Re: [PATCH] sata_nv: delay on switching between NCQ and non-NCQ commands
References: <45DA43F6.80201@shaw.ca>
In-Reply-To: <45DA43F6.80201@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This patch appears to solve some problems with commands timing out in
> cases where an NCQ command is immediately followed by a non-NCQ command
> (or possibly vice versa). This is a rather ugly solution, but until we
> know more about why this is needed, this is about all we can do.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

applied


