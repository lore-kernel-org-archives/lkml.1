Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbXFELko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbXFELko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXFELkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:40:35 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:44738 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbXFELkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:40:35 -0400
Message-ID: <46654BA0.50600@namesys.com>
Date: Tue, 05 Jun 2007 15:40:16 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Berck E. Nash" <flyboy@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       reiserfs-dev@namesys.com
Subject: Re: 2.6.22-rc3-mm1 reiser4 bug
References: <4661C0DA.7040308@gmail.com>
In-Reply-To: <4661C0DA.7040308@gmail.com>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I looked at your long attachment. It seems, you have problems with hardware.
Would you please check your root drive (sde) by badblocks program?

Thanks,
Edward.

Berck E. Nash wrote:

>All appears to work fine, until I try to boot a kernel with a Reiser4 /
>partition.  Then I get endless errors of the sort:
>
>[  206.349450] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET
>driverbyte=DRIVER_OK,SUGGEST_OK
>
>(See attached dmesg for more, I only sent the first 1,000 lines, it goes
>on until a hard reboot.)
>
>The same partition and the same kernel work great as long as that
>partition isn't the current system root.  The same kernel and the same
>hard drive works fine as long as the partition is formatted ReiserFS.
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
>
>  
>

