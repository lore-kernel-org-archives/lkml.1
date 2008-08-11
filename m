Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbYHKIDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbYHKIDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 04:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYHKIDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 04:03:19 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:6951 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYHKIDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 04:03:17 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Linux-fbdev-devel] [PATCH 0/13 v2] viafb: VIA Frame Buffer Device Driver
Date: Mon, 11 Aug 2008 16:03:12 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B70E3@exchtp03.taipei.via.com.tw>
In-Reply-To: <20080808182704.28bd9fb3.krzysztof.h1@poczta.fm>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 0/13 v2] viafb: VIA Frame Buffer Device Driver
Thread-Index: Acj5cuINkCmkElaDQBC7cUSnTq6kJACFUfyQ
From: <JosephChan@via.com.tw>
To: <krzysztof.h1@poczta.fm>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 11 Aug 2008 08:03:13.0925 (UTC) FILETIME=[B44EDB50:01C8FB88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

Thanks to remind, but after I checked the patches in linux-fbdev-devel mailing list.
It seems there is no missing lines as you mentioned. 

Would you please tell me the detailed problem you met? Thanks.

In addition, if possible, I could send you a file which includes all patches.
How do you think that? 

BRs,
Joseph

-----Original Message-----
From: Krzysztof Helt [mailto:krzysztof.h1@poczta.fm] 
Sent: Saturday, August 09, 2008 12:27 AM
To: Joseph Chan
Cc: linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; geert@linux-m68k.org
Subject: Re: [Linux-fbdev-devel] [PATCH 0/13 v2] viafb: VIA Frame Buffer Device Driver

On Fri, 8 Aug 2008 18:09:21 +0800
<JosephChan@via.com.tw> wrote:

> Hi all,
> 
> Here comes the 13 updated patchs for VIA Frame Buffer Device Driver.
> This driver could be used on VIA UniChrome (Pro) and Chrome9 family chips.
> All the patches are based on linux kernel 2.6.27-rc2 and they're modified by adopting community's feedback.
> I would like to thank all who provided their suggestions for VIAFB by mail.
> Any question, please contact me. Thanks.
> 

Please resend the 3rd patch as it is damaged (missing 3 lines of each file).

I am for merging these patches as they are sent now. It allows sending fixes to them as incremental patches.

This set builds at least for my configuration (Pentium3 SMP). 
Unfortunately, I do not have hardware to test. I though about buying one of these sexy VIA ITX boards but it is outside my budget now. Anyway, I have too many computers according to my spouse.

Kind regards,
Krzysztof


----------------------------------------------------------------------
Tylko dla detektywow! Konkurs na Smaker.pl Kliknij >>> http://link.interia.pl/f1eb1

