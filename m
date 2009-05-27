Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbZE0MsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbZE0MsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZE0Mr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:47:59 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:26645 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762139AbZE0Mr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:47:58 -0400
X-BigFish: VPS-35(zz1432R98dR14ffO936eN1805Mzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KKAZJE-03-EEK-01
Date: Wed, 27 May 2009 14:47:38 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 0/3] dma-debug fixes
Message-ID: <20090527124738.GH3927@amd.com>
References: <1243384983-3863-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1243384983-3863-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 May 2009 12:47:38.0785 (UTC) FILETIME=[51239910:01C9DEC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 09:43:00AM +0900, FUJITA Tomonori wrote:
> None of them is critical (we get bogus warnings due to the bugs but
> the bugs are in unpopular DMA mapping functions).
> 
> This patchset is against to tip/master.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

They all look good to me.

Ingo, do you want to pick them up youself or should I include them into
my dma-debug pull-request to you for 2.6.31?

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

