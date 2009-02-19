Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbZBSVnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbZBSVnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbZBSVmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:42:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45881 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbZBSVmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:42:52 -0500
Message-ID: <499DCF42.3030306@zytor.com>
Date: Thu, 19 Feb 2009 13:29:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Kyle McMartin <kyle@infradead.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] [trivial] fix references to Documentation/x86/i386/boot.txt
References: <20090219015904.GH17272@bombadil.infradead.org> <499CEBD7.1070000@oracle.com>
In-Reply-To: <499CEBD7.1070000@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Kyle McMartin wrote:
>> From: Kyle McMartin <kyle@redhat.com>
>>
>> The amazing dancing boot.txt file has jumped places again. :)
>>
>> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> Thanks.  I'll merge it if the x86 people don't.

I'll be happy to merge it if I get an unmolested patch.

boot.txt is one of several files which got moved into x86/i386 in 
error... they never were i386 specific (as opposed to x86 specific).

	-hpa
