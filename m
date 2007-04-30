Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbXD3LHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbXD3LHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbXD3LHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:07:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:57419 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbXD3LHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:07:14 -0400
Date: Mon, 30 Apr 2007 13:04:23 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Christoph Hellwig <hch@infradead.org>
cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [39/40] i386: Export paravirt_ops for non GPL modules
 too
In-Reply-To: <20070430105009.GB14944@infradead.org>
Message-ID: <Pine.LNX.4.61.0704301303400.29151@yvahk01.tjqt.qr>
References: <200704301227.598020000@suse.de> <20070430102814.7E56E151D2@wotan.suse.de>
 <20070430105009.GB14944@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30 2007 11:50, Christoph Hellwig wrote:
>On Mon, Apr 30, 2007 at 12:28:14PM +0200, Andi Kleen wrote:
>> 
>> Otherwise non GPL modules cannot even do basic operations
>> like disabling interrupts anymore, which would be excessive.
>> 
>> Longer term should split the single structure up into
>> internal and external symbols and not export the internal
>> ones at all.
>> 
>> Signed-off-by: Andi Kleen <ak@suse.de>
>
>Ingo was dead-set against this and I kinda agree. 

So would I, as unimportant as I am in that virtualization area.


Jan
-- 
