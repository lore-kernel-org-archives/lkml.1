Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbZLUIXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbZLUIXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 03:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZLUIXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 03:23:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:51202 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbZLUIXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 03:23:16 -0500
Message-ID: <4B2F3129.1090803@kernel.org>
Date: Mon, 21 Dec 2009 17:26:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Warn about flush_scheduled_work()
References: <Pine.LNX.4.44L0.0912161051160.2909-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912161051160.2909-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 12:52 AM, Alan Stern wrote:
> This patch (as1319) adds kerneldoc and a pointed warning to
> flush_scheduled_work().
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Queued in local queue.  Will commit to wq#for-next when and if it
opens.  If cmwq gets nacked upstream.  I'll route this one separately.
Thanks.

-- 
tejun
