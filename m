Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbYFPUWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbYFPUWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYFPUWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:22:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59726 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbYFPUWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:22:23 -0400
Message-ID: <4856CB79.9090602@garzik.org>
Date: Mon, 16 Jun 2008 16:22:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
References: <1213609751.26255.673.camel@pmac.infradead.org>	<4856C93B.7070804@garzik.org> <20080616210001.3c3588a7@lxorguk.ukuu.org.uk>
In-Reply-To: <20080616210001.3c3588a7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Anyone running 'make oldconfig' could easily skip over this and get a 
>> non-usable device, too.  Seems like a default 'y' is appropriate for the 
>> initial patch...
> 
> If you blindly type N N N N to make oldconfig then you have an operator
> error, and that should be fixed by fixing the operator.

Tell that to Linus and Ingo in the E1000 thread.

	Jeff




