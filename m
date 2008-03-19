Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbYCSVl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbYCSVl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764178AbYCSUKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:10:06 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:26481 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764126AbYCSUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:09:38 -0400
Message-ID: <47E08199.5070401@gmail.com>
Date: Wed, 19 Mar 2008 11:59:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Chris Wedgwood <cw@f00f.org>
CC: Jeff Garzik <jeff@garzik.org>, Len Brown <len.brown@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add 'short help text' to ATA_ACPI so it's [de]selectable.
References: <20080318220648.GA31208@puku.stupidest.org>
In-Reply-To: <20080318220648.GA31208@puku.stupidest.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wedgwood wrote:
> ATA_ACPI isn't selectable right now because it lacks 'short help
> text'.  This means it's always enabled and always enables ACPI_DOCK.
> Add text so it's now [de]selectable.
> 
> cc: Jeff Garzik <jeff@garzik.org>
> cc: Tejun Heo <htejun@gmail.com>
> cc: Len Brown <len.brown@intel.com>
> Signed-off-by: Chris Wedgwood <cw@f00f.org>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
