Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbXDEQ1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbXDEQ1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXDEQ1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:27:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:37799 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbXDEQ1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:27:03 -0400
Date: Thu, 5 Apr 2007 17:12:01 +0200
From: Stefan Seyfried <seife@suse.de>
To: Danny Kukawka <dkukawka@suse.de>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: more verbose thermal zone shutdown message
Message-ID: <20070405151201.GA23652@suse.de>
References: <200704051615.07960.dkukawka@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704051615.07960.dkukawka@suse.de>
X-Operating-System: openSUSE 10.3 (i586) Alpha3, Kernel 2.6.21-rc5-git8-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 04:15:07PM +0200, Danny Kukawka wrote:
> Hi,
> 
> while debug some strange termal shutdowns I wrote this patch to get more 
> information in /var/log/messages about the reason for the shutdown. I 
> think this would be useful in general.

Yes, especially as these were bogus thermal shutdowns, it is useful for
debugging to know from which thermal zone they were initiated.

> Danny
> 
> From: Danny Kukawka <dkukawka@suse.de>
> Subject: ACPI: more verbose thermal zone shutdown message
> 
> add more information to acpi thermal zone shutdown message for easier
> debugging
> 
> Signed-off-by: Danny Kukawka <dkukawka@suse.de>

FWIW:
Signed-off-by: Stefan Seyfried <seife@suse.de>

-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out." 
