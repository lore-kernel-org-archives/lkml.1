Return-Path: <linux-kernel-owner+w=401wt.eu-S1758452AbXFLF6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbXFLF6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXFLF5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:57:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:34688 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbXFLF5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ZjvwTxwJLVuyiY0mKxbs4q/k0nKJBeAETnIbEk3ZA7UiJ0a9Lljoi13i0fU9x+OKNTAEzT45IZ2bi4dF4ZrVdSbgDC4yv/Qv1+AQQgEZTVcOL+kewvP9rnIeSqT9nVXJ5kBM1/IbZ6IYg2yTVPWmIcVxJfcajnY8kTwRjKLpF2E=
Message-ID: <466E35C3.80809@gmail.com>
Date: Tue, 12 Jun 2007 07:57:23 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jiri Kosina <jikos@jikos.cz>, Greg KH <greg@kroah.com>,
       Joel.Becker@oracle.com,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] ThinkPad T41 - Strange USB 2.0 behaviour
References: <Pine.LNX.4.44L0.0706111722110.7362-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0706111722110.7362-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 12 Jun 2007, Robert de Rooy wrote:
>
>   
>> Yes that works.
>> I tried to plug and unplug the device repeatedly and each time it came 
>> up in full-speed mode.
>>     
>
> Good!  I'm glad that "companion" attribute file has come in handy for 
> someone.  :-)
>
> Alan Stern
>   

Any way of passing this as a boot parameter? Because I also encountered 
this when trying to boot Linux from a USB CD-ROM drive. The BIOS part 
worked fine, but the moment Linux loaded USB support it failed, due to 
the same problem. This is also why I asked if this failure mode could be 
handled automatically.

