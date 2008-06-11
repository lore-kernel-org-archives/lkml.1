Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYFKPEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYFKPEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYFKPEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:04:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48652 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYFKPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:04:35 -0400
Message-ID: <484FE97D.4040805@firstfloor.org>
Date: Wed, 11 Jun 2008 17:04:29 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Patrick <ragamuffin@datacomm.ch>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
 Disk Corruption
References: <1211717435.6038.53.camel@localhost.localdomain> <200806090036.32267.rjw@sisk.pl> <1213184587.6376.37.camel@localhost.localdomain> <200806111638.50933.rjw@sisk.pl>
In-Reply-To: <200806111638.50933.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Well, I was hoping to be able to get this patch into 2.6.26, as I don't really
> like the temporary hack, preventing the affected systems from resuming
> at all, that we have in there, but it seems to be too late. :-(

I agree with you that this patch would be far better than the hack.

-Andi
