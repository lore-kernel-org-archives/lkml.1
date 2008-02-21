Return-Path: <linux-kernel-owner+w=401wt.eu-S934371AbYBUVTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371AbYBUVTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYBUVTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:19:34 -0500
Received: from gw.goop.org ([64.81.55.164]:37264 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYBUVTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:19:33 -0500
Message-ID: <47BDEA5E.4070800@goop.org>
Date: Thu, 21 Feb 2008 13:17:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: Implement getgeo for Xen virtual block device.
References: <47BDE731.60801@goop.org> <alpine.LFD.1.00.0802211315190.19896@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802211315190.19896@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 21 Feb 2008, Jeremy Fitzhardinge wrote:
>   
>> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
>> From: Ian Campbell <ijc@hellion.org.uk>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>>     
>
> This is just wrong. The From: goes at the *top*, and if it's not there, 
> my scripts won't pick it up as the author. 

OK.  Have you fixed it, or shall I resend?

Thanks,
    J
