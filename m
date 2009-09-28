Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZI1UgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZI1UgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZI1UgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:36:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44432 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbZI1UgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:36:11 -0400
Message-ID: <4AC11E38.4050703@garzik.org>
Date: Mon, 28 Sep 2009 16:36:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Jung-Ik (John) Lee" <jilee@google.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Grant Grundler <grundler@google.com>,
       Gwendal Gringo <gwendal@google.com>
Subject: Re: [git patches] libata updates
References: <20090917204935.GA7432@havoc.gtf.org> <200909202305.06199.bzolnier@gmail.com> 	<8b5805ff0909211936s4968d11fnd3e6604d38e31c79@mail.gmail.com> 	<200909281734.11090.bzolnier@gmail.com> <8b5805ff0909281320x57660c0cvb6e72290c6781a99@mail.gmail.com>
In-Reply-To: <8b5805ff0909281320x57660c0cvb6e72290c6781a99@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2009 04:20 PM, Jung-Ik (John) Lee wrote:
>> Thanks, your patch looks good to me but since there are still some
>> leftover issues left we would also need something like the incremental
>> patch below:
>
> [resending - bounced back from -ide, -kernel]
>
> your patch below looks good to me.


By convention, you should reply to a patch such as Bart's, and provide 
an explicit line of text that may be pasted into the patch at merge time:

Acked-by: Your Name <your@email.address>

