Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYBEEt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYBEEt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 23:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYBEEtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 23:49:17 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41370 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbYBEEtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 23:49:16 -0500
Message-ID: <47A7EAC6.8020201@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2008 10:19:10 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, apw@shadowen.org, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] 2.6.24-mm1 section type conflict cleanup
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <20080204162223.GA6888@linux.vnet.ibm.com> <20080204180454.GA16050@uranus.ravnborg.org>
In-Reply-To: <20080204180454.GA16050@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, Feb 04, 2008 at 09:52:23PM +0530, Kamalesh Babulal wrote:
>> Hi Andrew,
>>
>> The 2.6.24-mm1 kernel build fails at many places with section type
>> conflict build error.
> 
> What arch?
> We have troubles with powerpc as pointed out by Al in another thread.
> 
> 	Sam
Hi Sam,

This clean up is done for the powerpc, sorry forgot to mention it.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
