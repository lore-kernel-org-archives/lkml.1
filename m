Return-Path: <linux-kernel-owner+w=401wt.eu-S1763300AbXHOIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763300AbXHOIQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbXHOIPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:15:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41718 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbXHOIPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:15:52 -0400
Message-ID: <46C2B635.70104@garzik.org>
Date: Wed, 15 Aug 2007 04:15:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: htejun@gmail.com, akpm@linux-foundation.org, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [patch 1/4] Store interrupt value
References: <20070809211800.022150464@intel.com> <20070809142341.817322f1.kristen.c.accardi@intel.com>
In-Reply-To: <20070809142341.817322f1.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Use a stored value for which interrupts to enable.  Changing this allows
> us to selectively turn off certain interrupts later and have them 
> stay off.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

applied, after adding "ahci: " prefix to subject line


