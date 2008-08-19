Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYHSOZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYHSOZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYHSOYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:24:53 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:12732 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYHSOYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:24:52 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K5UQP2-03-A3N-01
Date: Tue, 19 Aug 2008 16:24:40 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix build error in kernel/rcuclassic.c with latest tip/master
Message-ID: <20080819142440.GW14993@amd.com>
References: <1219139452-7435-1-git-send-email-joerg.roedel@amd.com> <20080819095802.GA6722@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080819095802.GA6722@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Aug 2008 14:24:41.0094 (UTC) FILETIME=[516DB260:01C90207]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 11:58:02AM +0200, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch fixes the following build error for me:
> 
> just pushed out a similar fix from Hiroshi Shimamo - please check 
> whether latest tip/master build fine for you.

It builds fine now. Thanks.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

