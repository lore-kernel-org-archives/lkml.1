Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYBKKDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYBKKDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYBKKDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:03:08 -0500
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:60013 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbYBKKDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:03:06 -0500
Message-ID: <47B01D47.10006@vlnb.net>
Date: Mon, 11 Feb 2008 13:02:47 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: ltuikov@yahoo.com
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       scst-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <462600.51623.qm@web31810.mail.mud.yahoo.com>
In-Reply-To: <462600.51623.qm@web31810.mail.mud.yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luben Tuikov wrote:
>>>Is there an open iSCSI Target implementation which
>>
>>does NOT
>>
>>>issue commands to sub-target devices via the SCSI
>>
>>mid-layer, but
>>
>>>bypasses it completely?
>>
>>What do you mean? To call directly low level backstorage
>>SCSI drivers 
>>queuecommand() routine? What are advantages of it?
> 
> Yes, that's what I meant.  Just curious.

What's advantage of it?

> Thanks,
>    Luben
