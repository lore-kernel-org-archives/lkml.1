Return-Path: <linux-kernel-owner+w=401wt.eu-S1161678AbXBOXJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161678AbXBOXJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161681AbXBOXJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:09:51 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60330 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161673AbXBOXJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:09:48 -0500
Message-ID: <45D4E83A.30605@garzik.org>
Date: Thu, 15 Feb 2007 18:09:46 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] sata_nv: handle SError status indication
References: <45CFB6A8.3010507@shaw.ca>
In-Reply-To: <45CFB6A8.3010507@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> ADMA-capable controllers provide a bit in the status register that appears
> to indicate that the controller detected an SError condition. Update 
> sata_nv
> to detect this and trigger error handling in order to handle the fault.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

applied


