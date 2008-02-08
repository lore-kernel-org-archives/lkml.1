Return-Path: <linux-kernel-owner+w=401wt.eu-S934250AbYBHKcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250AbYBHKcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761021AbYBHKcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:32:08 -0500
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:54892 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760884AbYBHKcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:32:06 -0500
Message-ID: <47AC2FA7.7020700@vlnb.net>
Date: Fri, 08 Feb 2008 13:32:07 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: ltuikov@yahoo.com
CC: Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ming Zhang <blackmagic02881@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <393719.81864.qm@web31808.mail.mud.yahoo.com>
In-Reply-To: <393719.81864.qm@web31808.mail.mud.yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luben Tuikov wrote:
> Is there an open iSCSI Target implementation which does NOT
> issue commands to sub-target devices via the SCSI mid-layer, but
> bypasses it completely?

What do you mean? To call directly low level backstorage SCSI drivers 
queuecommand() routine? What are advantages of it?

>    Luben
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

