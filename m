Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYIZXI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYIZXI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 19:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYIZXIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 19:08:51 -0400
Received: from mga05.intel.com ([192.55.52.89]:29816 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752105AbYIZXIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 19:08:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,316,1220252400"; 
   d="scan'208";a="620793656"
Message-ID: <48DD6B8E.5050106@linux.intel.com>
Date: Fri, 26 Sep 2008 16:09:02 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net
Subject: Re: [PATCH] oprofile: Implement Intel architectural perfmon support
References: <1219250433-25516-1-git-send-email-andi@firstfloor.org> <1219250433-25516-2-git-send-email-andi@firstfloor.org> <1219250433-25516-3-git-send-email-andi@firstfloor.org> <20080925200048.GI23557@erda.amd.com> <48DC3077.1080905@linux.intel.com> <20080926032328.GN23557@erda.amd.com>
In-Reply-To: <20080926032328.GN23557@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:

> I think this would be the best solution, providing a parameter
> 
>  oprofile.force_pmu=<oprofile arch string>
> 
> This can easily be implemented and also reused by others. I would be
> fine with this solution. No separate patch needed then.

Ok I can implement that, but it'll be a separate patch. Might be until
next week that I can work on it though.

-Andi

