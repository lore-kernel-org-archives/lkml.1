Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYKIOzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYKIOzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 09:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbYKIOzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 09:55:42 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:26771 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754800AbYKIOzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 09:55:41 -0500
Message-ID: <4916F9F5.9040409@panasas.com>
Date: Sun, 09 Nov 2008 16:55:49 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: open-osd development <osd-dev@open-osd.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [osd-dev] [PATCH 04/18] libosd: OSDv1 preliminary implementation
References: <491073BB.4000900@panasas.com>	<1225817069-5969-1-git-send-email-bharrosh@panasas.com>	<20081104180347.GA9818@uranus.ravnborg.org> <49119BAF.6040603@panasas.com>
In-Reply-To: <49119BAF.6040603@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Nov 2008 14:54:19.0511 (UTC) FILETIME=[0B521870:01C9427B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> Sam Ravnborg wrote:
>>> +EXPORT_SYMBOL(osd_dev_init);
>> kernel-doc comments for all exported funtions / variables.
>>
> 
> I have some kernel-doc comments of exported functions in the Header
> file. I have not yet finished all of them. (Laziness on my part).
> 
> Are kernel-doc comments in headers a big NO-NO. I like it this way,
> so when I have to learn a new Library all the information
> I need to know is in the header. Also the header is a much better place
> when you do programing by shopping, that is you don't know what you need
> and you look for what's available.
> 
> Thanks
> Boaz

Sam please comment if kernel-doc comments are OK in headers

Thanks
Boaz
