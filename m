Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbXFGGwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbXFGGwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXFGGwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:52:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2760 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbXFGGwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:52:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cqE+81de4w8UtWZB777srT/Ee1uae0ebLbkkQG+VFkdgFkeaSO6S26YzEEcWXnlTdxAgNd+S8NfMM4Iq4Y+k5qBDQhuOUnfbGQGdlGrIUWi1K9y04J7l+GPGdehvFshhSRlZ1Ke/QLEpTS8RQjHIMzolc7rA+XNnxbETr4dyMZA=
Message-ID: <4667AB10.4070201@gmail.com>
Date: Thu, 07 Jun 2007 15:52:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Peer Chen <pchen@nvidia.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org
Subject: Re: [PATCH] ahci: Add MCP73/MCP77 support to AHCI driver
References: <15F501D1A78BD343BE8F4D8DB854566B14BFA227@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B14BFA227@hkemmail01.nvidia.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peer Chen wrote:
> Add the MCP73/MCP77 support to ahci driver.
> The patch base on kernel 2.6.22-rc4

Please resend in plain text.  My recommendations...

1. If you can setup a linux machine with working MTA, use
git-format-patch and git-send-email.  If you don't feel comfortable with
git, you can use mutt + your favorite editor (I use emacs).

2. Use firefox + external editor plugin with line-wrap turned off.

Thanks.

-- 
tejun
