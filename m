Return-Path: <linux-kernel-owner+w=401wt.eu-S1751304AbYKGEIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbYKGEIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 23:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYKGEHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 23:07:44 -0500
Received: from relay2.sgi.com ([192.48.179.30]:36913 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751265AbYKGEHn (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 23:07:43 -0500
Message-ID: <4913BEC6.6080901@sgi.com>
Date: Fri, 07 Nov 2008 15:06:30 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Chinner <david@fromorbit.com>, linux-next@vger.kernel.org,
       linuxfs-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: unable to fetch the xfs tree
References: <20081107111125.ef33b1dc.sfr@canb.auug.org.au> <20081107145332.52d49390.sfr@canb.auug.org.au>
In-Reply-To: <20081107145332.52d49390.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> On Fri, 7 Nov 2008 11:11:25 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> I am getting:
>>
>> oss.sgi.com[0: 192.48.170.157]: errno=Connection refused
>>
>> so I will use what I fetched yesterday.
> 
> And now I have received:
> 
> <xfs-masters@oss.sgi.com>: host cuda-allmx.sgi.com[192.48.176.16] said: 550
>     cuda_nsu 5.1.1 <xfs-masters@oss.sgi.com>... User unknown (in reply to RCPT
>     TO command)
> 
> So, is this a permanent state of affairs, or just a temporary glitch?

Should be temporary.  We have known DNS and email issues that we are working
on.  We're also moving oss.sgi.com but I have no idea what the schedule is.
