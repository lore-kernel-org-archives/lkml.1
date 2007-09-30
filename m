Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbXI3I1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbXI3I1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 04:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbXI3I04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 04:26:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:38469 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbXI3I0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 04:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=R/PpT/yPpcOJupemLYmi/ERGBqVM1WLzQ3QwYgQIFqVLSInBhcWCAGkIwMn7jkuAMJ+92b2WmKkp+zKQNvpkOzxZ8zBmtCMsqKvky9rEwZ6NWDN8x86uGB3W1xLkBkuLW7/EyylJJNuTRm4xxiAB0K7wC1465cHQCE8Gq39llOs=
Message-ID: <46FF5DC9.8030106@gmail.com>
Date: Sun, 30 Sep 2007 10:26:49 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] 2.6.23-rc7-mm1
References: <Pine.LNX.4.44L0.0709241540420.5920-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709241540420.5920-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2007 09:41 PM, Alan Stern wrote:
> On Mon, 24 Sep 2007, Jiri Slaby wrote:
> 
>> Hmm, I have usb legacy keyboard switched on because of grub and bios to allow me
>>  typing.
>>
>> I booted 23-rc7 4 times, and the latest -mm 3 times just now and can't reproduce
>> it, I just wonder by what is this conditioned.
> 
> Warm boot vs. cold boot, maybe.

Hmm, no. I don't know, I can't see it anymore so far (using rc8-mm2). I'll keep
eyes on it, anyways.

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
