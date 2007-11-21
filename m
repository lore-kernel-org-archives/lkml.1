Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbXKUERu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbXKUERu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 23:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXKUERm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 23:17:42 -0500
Received: from rtr.ca ([76.10.145.34]:2097 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXKUERl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 23:17:41 -0500
Message-ID: <4743B160.7060007@rtr.ca>
Date: Tue, 20 Nov 2007 23:17:36 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Laurent Pinchart <laurentp@cse-semaphore.com>
Subject: Re: USB deadlock after resume
References: <d9def9db0711201347u2786fe0ev96b2fb43fc2954e9@mail.gmail.com>
In-Reply-To: <d9def9db0711201347u2786fe0ev96b2fb43fc2954e9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger wrote:
> Hi,
> 
> I'm looking at the linux uvc driver, and noticed after resuming my
..

Pardon me.. what is the "uvc" driver?  Which module/source file is that?

Thanks


> notebook it deadlocks at usb_set_interface.
> The linux kernel version on that notebook is 2.6.21.4, I searched
> around and haven't found any such bugreports.
> I wonder if anyone has ever heard about such a problem?
> 
> I'm digging closer into that issue now..
> 
> thanks,
> Markus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

