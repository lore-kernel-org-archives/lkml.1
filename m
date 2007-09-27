Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbXI0SR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbXI0SR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbXI0SRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:17:50 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:25740 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbXI0SRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Kxj1cvKF9Q4TedYk7cbWksyC/0zKxZF/vM2prSqciL6jtWPvcSJIOV0rT/6LIa3IsAsPlthuFHWF5DRzBwkP95lIk1BfbG1lmZIqIvDZJQZAWt3bwRFm6UUsu+CIWHu5HYaeUHQIJjG3x2cWlJYOvkFLGjgL50U+T9IPL6zr3cg=
Message-ID: <46FB5BF3.8000309@gmail.com>
Date: Thu, 27 Sep 2007 16:29:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: hgsolari@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Serial ATA does not find partitions (Hitachi HD, new? ATI controller)
 where old SATA works
References: <46F5AB46.3030202@gmail.com>
In-Reply-To: <46F5AB46.3030202@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hernan G Solari wrote:
> Hello
>     I am disturbing you with this problem because I think there is
> something to be learnt, I have
> no urgency or further-problem with my work-around.
> 
> Description: trying to boot with kernel 2.6.22  the booting process
> stops not finding
> the root partition, in the previous line it gives an EMPTY list of
> available partitions.
> Disabling completely the (Serial) ATA driver and enabling the old SATA
> driver is my work-around (a regresion).
> Installing linux with debian 4.0 is possible (kernel 2.6.18.4-amd64),
> but ubuntu crashes
> silently after loading kernel and initrd.image (I guess it is the same
> problem).

Can you set up netconsole and collect the kernel log from the failing
boot and post it here?

Thanks.

-- 
tejun

