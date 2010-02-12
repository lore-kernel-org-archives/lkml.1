Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0BLIk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 03:40:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:49987 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab0BLIkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 03:40:25 -0500
Message-ID: <4B7515B1.5070707@kernel.org>
Date: Fri, 12 Feb 2010 17:47:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Warn about flush_scheduled_work()
References: <Pine.LNX.4.44L0.0912161051160.2909-100000@iolanthe.rowland.org> <4B2F3129.1090803@kernel.org>
In-Reply-To: <4B2F3129.1090803@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Feb 2010 08:40:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 05:26 PM, Tejun Heo wrote:
> On 12/17/2009 12:52 AM, Alan Stern wrote:
>> This patch (as1319) adds kerneldoc and a pointed warning to
>> flush_scheduled_work().
>>
>> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

applied to wq tree.  will push out when merge window opens.

Thanks.

-- 
tejun
