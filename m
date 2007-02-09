Return-Path: <linux-kernel-owner+w=401wt.eu-S1423209AbXBIVKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423209AbXBIVKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423224AbXBIVKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:10:52 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60267 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423209AbXBIVKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:10:51 -0500
Message-ID: <45CCE357.3030203@pobox.com>
Date: Fri, 09 Feb 2007 16:10:47 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH][RESEND] gianfar: Convert network devices to use struct
 device instead of class_device
References: <Pine.LNX.4.64.0702081118090.29779@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0702081118090.29779@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> Convert network devices to use struct device instead of class_device.  Greg
> missed this one in his cleanup path.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

OK, but doesn't apply to torvalds/linux-2.6.git ...

	Jeff



