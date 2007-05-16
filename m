Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbXEPTlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbXEPTlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbXEPTlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:41:46 -0400
Received: from Mail.MNSU.EDU ([134.29.1.12]:42804 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXEPTlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:41:45 -0400
X-Greylist: delayed 1461 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 15:41:45 EDT
Message-ID: <464B58A2.6010202@mnsu.edu>
Date: Wed, 16 May 2007 14:16:50 -0500
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
References: <20070516144205.GV26766@think.oraclecorp.com> <Pine.LNX.4.61.0705162010370.9019@yvahk01.tjqt.qr> <464B57B7.7090404@garzik.org>
In-Reply-To: <464B57B7.7090404@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jan Engelhardt wrote:
>> On May 16 2007 10:42, Chris Mason wrote:
>>> For example, I'll pick on xfs for a minute.  compilebench shows the
>>> default FS you get from mkfs.xfs is pretty slow for untarring a 
>>> bunch of
>>> kernel trees.
>>
>> I suppose you used 'nobarrier'? [ http://lkml.org/lkml/2006/5/19/33 ]
>
> Shouldn't that option be renamed to 'corrupt_my_data'?  ;-)

Perhaps maybe "my_power_never_fails".
>
>     Jeff
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
