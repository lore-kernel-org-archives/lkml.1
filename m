Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbYGZJTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbYGZJTi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYGZJTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:19:13 -0400
Received: from h155.mvista.com ([63.81.120.155]:18499 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754468AbYGZJTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:19:12 -0400
Message-ID: <488AEC02.9040602@ru.mvista.com>
Date: Sat, 26 Jul 2008 13:18:58 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Add documentation for hard disk shock protection
 interface
References: <87prp1kvyy.fsf@denkblock.local> <20080726062142.29070.60679.stgit@denkblock.local>
In-Reply-To: <20080726062142.29070.60679.stgit@denkblock.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Elias Oltmanns wrote:
> Put some information (and pointers to more) into the kernel's doc tree,
> describing briefly how to set up disk shock protection under GNU/Linux.
>
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
>   
[...]
> diff --git a/Documentation/laptops/disk-shock-protection.txt b/Documentation/laptops/disk-shock-protection.txt
> new file mode 100644
> index 0000000..ac26040
> --- /dev/null
> +++ b/Documentation/laptops/disk-shock-protection.txt
>   
[...]
> +
> +- http://www.thinkwiki.org/wiki/HDAPS
> +  See this page for information about Linux support of the hard disk
> +  active protection syystem as implemented in IBM/Lenovo Thinkpads.
>   

   A typo in "system". :-)

MBR, Sergei


