Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbXHUTB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbXHUTB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760164AbXHUTBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:01:19 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:36707 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759383AbXHUTBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:01:18 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <46CB3679.3070403@am.sony.com>
Date: Tue, 21 Aug 2007 12:01:13 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: cbe-oss-dev-owner@ozlabs.org
CC: Satyam Sharma <satyam@infradead.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       mokuno@sm.sony.co.jp
Subject: Re: [PATCH] PS3: Update MAINTAINERS
References: <20070816211551.11839.patches@notabene> <1070816112100.12182@suse.de> <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be> <alpine.LFD.0.999.0708181953560.29105@enigma.security.iitk.ac.in> <Pine.LNX.4.64.0708181628350.5186@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.999.0708182016000.29105@enigma.security.iitk.ac.in> <Pine.LNX.4.62.0708201313260.6197@pademelon.sonytel.be> <alpine.LFD.0.999.0708210523470.2774@enigma.security.iitk.ac.in> <Pine.LNX.4.62.0708210904220.11703@pademelon.sonytel.be> <alpine.LFD.0.999.0708211500100.2774@enigma.security.iitk.ac.in> <Pine.LNX.4.62.0708211148040.6982@pademelon.sonytel.be> <alpine.LFD.0.999.0708211605320.2774@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708211605320.2774@enigma.security.iitk.ac.in>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Aug 2007 19:01:14.0259 (UTC) FILETIME=[A55CBE30:01C7E425]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> 
> On Tue, 21 Aug 2007, Geert Uytterhoeven wrote:
> 
>> On Tue, 21 Aug 2007, Satyam Sharma wrote:
>> > On Tue, 21 Aug 2007, Geert Uytterhoeven wrote:
>> > > 
>> > > [ and you dropped the cell mailing list from the CC list ]
>> > 
>> > I don't enjoy getting "this is a subscriber-only list" notifications,
>> > thank you.
>> 
>> IC.
> 
> [PATCH] PS3: Update MAINTAINERS
> 
> Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org> is an
> subscribers-only mailing list.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> 
> ---
> 
>  MAINTAINERS |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 371fe67..ec1bc77 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3029,14 +3029,14 @@ PS3 NETWORK SUPPORT
>  P:	Masakazu Mokuno
>  M:	mokuno@sm.sony.co.jp
>  L:	netdev@vger.kernel.org
> -L:	cbe-oss-dev@ozlabs.org
> +L:	cbe-oss-dev@ozlabs.org	(subscribers-only)
>  S:	Supported
>  
>  PS3 PLATFORM SUPPORT
>  P:	Geoff Levand
>  M:	geoffrey.levand@am.sony.com
>  L:	linuxppc-dev@ozlabs.org
> -L:	cbe-oss-dev@ozlabs.org
> +L:	cbe-oss-dev@ozlabs.org	(subscribers-only)
>  S:	Supported

Hi Hugh,

Could you verify that cbe-oss-dev is a subscriber's
only list?  I didn't see anything that said it
specifically in the listinfo.

-Geoff


