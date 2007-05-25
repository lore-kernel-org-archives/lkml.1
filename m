Return-Path: <linux-kernel-owner+w=401wt.eu-S1765440AbXEYUaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765440AbXEYUaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbXEYU3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:29:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:42903 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974AbXEYU3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:29:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,581,1170662400"; 
   d="scan'208";a="232194535"
Message-ID: <4657473A.6020203@intel.com>
Date: Fri, 25 May 2007 13:29:46 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [CodingStyle] Add comment to not put spaces before
 tabs.
References: <20070525172509.5138.56430.stgit@localhost.localdomain> <46571DA8.1000402@s5r6.in-berlin.de> <46573C70.2070209@zytor.com>
In-Reply-To: <46573C70.2070209@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2007 20:29:47.0606 (UTC) FILETIME=[70032760:01C79F0B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Stefan Richter wrote:
>> Auke Kok wrote:
>>> +Don't put spaces before tabs or mix them.
>> Make it "Don't put spaces before tabs."
>>
>> We do mix them if we combine tabs for indentation with spaces for alignment.
> 
> It would probably be good to add a pointer to the cleanfile/cleanpatch
> scripts here, too.

ahh yes, I'll incorporate that.

BTW, would it be possible for cleanfile/cleanpatch to dump warnings to stderr 
for lines exceeding 80 characters? I think that would really be useful...

Auke
