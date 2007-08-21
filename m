Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbXHUURw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbXHUURw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXHUURo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:17:44 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:61289 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbXHUURn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:17:43 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <46CB4862.9020601@am.sony.com>
Date: Tue, 21 Aug 2007 13:17:38 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Joe Perches <joe@perches.com>, cbe-oss-dev-owner@ozlabs.org,
       Satyam Sharma <satyam@infradead.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       mokuno@sm.sony.co.jp
Subject: Re: [PATCH] PS3: Update MAINTAINERS
References: <20070816211551.11839.patches@notabene>	 <1070816112100.12182@suse.de>	 <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be>	 <alpine.LFD.0.999.0708181953560.29105@enigma.security.iitk.ac.in>	 <Pine.LNX.4.64.0708181628350.5186@fbirervta.pbzchgretzou.qr>	 <alpine.LFD.0.999.0708182016000.29105@enigma.security.iitk.ac.in>	 <Pine.LNX.4.62.0708201313260.6197@pademelon.sonytel.be>	 <alpine.LFD.0.999.0708210523470.2774@enigma.security.iitk.ac.in>	 <Pine.LNX.4.62.0708210904220.11703@pademelon.sonytel.be>	 <alpine.LFD.0.999.0708211500100.2774@enigma.security.iitk.ac.in>	 <Pine.LNX.4.62.0708211148040.6982@pademelon.sonytel.be>	 <alpine.LFD.0.999.0708211605320.2774@enigma.security.iitk.ac.in>	 <46CB3679.3070403@am.sony.com> <1187726479.5963.118.camel@localhost> <46CB45D8.9020801@gmail.com>
In-Reply-To: <46CB45D8.9020801@gmail.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Aug 2007 20:17:39.0337 (UTC) FILETIME=[52481F90:01C7E430]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 08/21/2007 10:01 PM, Joe Perches wrote:
> 
>> On Tue, 2007-08-21 at 12:01 -0700, Geoff Levand wrote:
> 
>>> Could you verify that cbe-oss-dev is a subscriber's
>>> only list?  I didn't see anything that said it
>>> specifically in the listinfo.
>> 
>> This is the "hold" message I got on posting to that list.
>> 
>> Your mail to 'cbe-oss-dev' with the subject
>> 
>>     Re: [PATCH] [392/2many] MAINTAINERS - PS3 PLATFORM SUPPORT
>> 
>> Is being held until the list moderator can review it for approval.
>> 
>> The reason it is being held:
>> 
>>     Post by non-member to a members-only list
> 
> That means it's not a subcriber-only list -- the message wasn't rejected, 
> just subjected to moderation.
> 

So maybe it would be more precise to have something like this:

-L:	cbe-oss-dev@ozlabs.org
+L:	cbe-oss-dev@ozlabs.org	(moderated)

