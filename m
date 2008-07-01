Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYGAIdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYGAIdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYGAIdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:33:31 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:50212 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYGAIda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:33:30 -0400
Message-ID: <4869EBE4.7020200@linux.vnet.ibm.com>
Date: Tue, 01 Jul 2008 14:03:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Priority heap infrastructure enhancements
References: <1213796886-24863-1-git-send-email-balbir@linux.vnet.ibm.com> <6599ad830806210029x2a020e1ava6b646be9913fcdf@mail.gmail.com> <485CB652.90801@linux.vnet.ibm.com> <20080701011414.2f0cccb5.akpm@linux-foundation.org>
In-Reply-To: <20080701011414.2f0cccb5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>>> Reviewed-by: Paul Menage <menage@google.com>
>> Thanks for the review!
>>
> 
> yup, thanks.
> 
> I'll duck the patch until we have some code which uses it.  Please
> retain Paul's Reviewed-by: for that occasion.

Sure, I'll keep the reviewed-by around. I might move over to a different data
structure for soft limits, but I don't know for sure yet.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
