Return-Path: <linux-kernel-owner+w=401wt.eu-S936887AbYEUTG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936887AbYEUTG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbYEUTGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:06:41 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:51785 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbYEUTGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:06:40 -0400
MIME-Version: 1.0
Date: Wed, 21 May 2008 14:06:33 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: David Brownell <david-b@pacbell.net>
Cc: Tony Lindgren <tony@atomide.com>, Bryan Wu <cooloney@kernel.org>,
       linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] MUSB: 2 patches to fix some bug found on Blackfin
In-Reply-To: <200805211014.45170.david-b@pacbell.net>
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org> <386072610805190105y6618dd9bwe32503c1ae11b865@mail.gmail.com> <20080521155003.GZ23002@atomide.com> <200805211014.45170.david-b@pacbell.net>
Message-ID: <61cdb2dcc22913ddefddd7b4a6faede3@felipebalbi.com>
User-Agent: FelipeBalbi.com Webmail
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 May 2008 10:14:44 -0700, David Brownell <david-b@pacbell.net>
wrote:
> On Wednesday 21 May 2008, Tony Lindgren wrote:
>>
>> > Great, after I enable the DMA mode 1 on Blackfin and cleanup the code,
>> > I will send
>> > out the code before you sent them to upstream
>>
>> Maybe we should get the musb code to USB tree before that? It's been out
>> of the scope for linux-omap tree for quite a while now.
> 
> I'm all for getting the musb_hdrc driver into the 2.6.27 queue...
> I presume there are still some infrastructure changes in usbcore
> that block that merge?  It'd be nice if we could merge musb_hdrc
> without those changes (OTG related) and then update that stuff
> separately.

Ok then, I'll prepare the patches during the next week and post
here on l-o so people can comment.

Any otg related stuff will come later.

-- 
Best Regards,

Felipe Balbi
http://felipebalbi.com
me@felipebalbi.com

