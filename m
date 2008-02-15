Return-Path: <linux-kernel-owner+w=401wt.eu-S1765497AbYBOMhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765497AbYBOMhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761999AbYBOMhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:37:38 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46481 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761741AbYBOMh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:37:26 -0500
Message-ID: <47B5877E.8050309@bull.net>
Date: Fri, 15 Feb 2008 13:37:18 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-mm1 0/8] (resend) IPC: code rewrite
References: <20080212161340.200976067@bull.net> <p73y79mzcte.fsf@bingen.suse.de>
In-Reply-To: <p73y79mzcte.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andi Kleen wrote:
> pierre.peiffer@bull.net writes:
> 
>> 	This is a resend of the first part of the patchset sent 2 weeks
>> ago. This is the part about the IPC which (again) proposes to consolidate
>> some part of the existing code.
>>
>> 	It does not change the behavior of the existing code, but
>> improves it in term of readability and maintainability as it consolidates it
>> a little. As there was no objection, I think you can include them in your 
>> -mm tree.
>>
>> 	The patchset applies on top of "2.6.24-mm1 + previous patches about
>> IPC" sent the last days (ie Nadia's patches + mine).
> 
> While I have not read everything in detail from a quick overview
> the whole patch series looks like a nice and valuable cleanup to me.
> 
> I was a bit sceptical about all the interface enhancements your original
> patchkit had, but this one looks just fine.
> 

Thanks Andi for spending time on this review.
All kind of comments (positive or negative) are always welcome to make progress,
but of course, I particularly appreciate such positive feedbacks ;)

-- 
Pierre
