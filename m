Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbYEFIHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbYEFIHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYEFIG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:06:58 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:36914 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbYEFIGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:06:55 -0400
Message-ID: <48200FDF.7070408@linux.vnet.ibm.com>
Date: Tue, 06 May 2008 13:29:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       rientjes@google.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 4/4] Add rlimit controller documentation
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain> <20080503213825.3140.4328.sendpatchset@localhost.localdomain> <20080505153509.da667caf.akpm@linux-foundation.org> <481FEF28.1000502@linux.vnet.ibm.com> <20080505225434.3f81828b.akpm@linux-foundation.org>
In-Reply-To: <20080505225434.3f81828b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 06 May 2008 11:09:52 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>> Ho hum, I had to do rather a lot of guesswork here to try to understand
>>> your proposed overall design for this feature.  I'd prefer to hear about
>>> your design via more direct means.
>> Do you have any suggestions on how to do that better. Would you like
>> documentation to be the first patch in the series? I had sent out two RFC's
>> earlier and got comments and feedback from several people.
>>
> 
> I do like to see the overall what-i-am-setting-out-to-do description in
> there somewhere - sometimes a Docuemtation/ file is appropriate, other
> times do it via changelog.
> 

I think having documentation upfront does make sense in that case. I'll also try
and make the changelogs more verbose. I usually try to point to the previous
discussions in the introduction patch.

> But the first part of the review is reviewing whatever it is which you set
> out to achieve.  Once that's understood and sounds like a good idea then we
> can start looking at how you did it.
> 
> 

Yes, I agree.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
