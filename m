Return-Path: <linux-kernel-owner+w=401wt.eu-S934763AbXK3RlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934763AbXK3RlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758532AbXK3Rk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:40:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52362 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbXK3Rk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:40:56 -0500
Message-ID: <47504B00.9000106@zytor.com>
Date: Fri, 30 Nov 2007 09:40:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/Changes -> Documentation/Requirements (resend
 without truncated comment text)
References: <20071130071647.GA2017@ff.dom.local>
In-Reply-To: <20071130071647.GA2017@ff.dom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On 30-11-2007 04:32, H. Peter Anvin wrote:
> ...
>> As far as I can tell, Documentation/Changes is the only thing we have
>> that even attempts to document the basic requirements.  This attempts
>> to formalize that fact.
>>
>>  Documentation/Changes      |  396 --------------------------------------------
>>  Documentation/Requirements |  394 +++++++++++++++++++++++++++++++++++++++++++
> 
> ...But, there are a few more 'things', which mention Documentation/Changes.
> 

Uh, right :)

Updated patchset will follow...

	-hpa
