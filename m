Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab0BDTAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:00:24 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40210 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab0BDTAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:00:20 -0500
Date: Thu, 4 Feb 2010 19:00:12 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off
	switch out of staging."
Message-ID: <20100204190012.GA21950@srcf.ucam.org>
References: <20100204062619.GA29154@elte.hu> <20100204071705.GA28403@elte.hu> <20100204164859.GA17878@srcf.ucam.org> <20100204170826.GA16397@elte.hu> <20100204173602.GA19855@srcf.ucam.org> <20100204175445.GB27361@elte.hu> <20100204175928.GA20595@srcf.ucam.org> <20100204181218.GA6175@elte.hu> <20100204181540.GA20922@srcf.ucam.org> <20100204185603.GA6665@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204185603.GA6665@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 07:56:03PM +0100, Ingo Molnar wrote:

> Do you see my argument why any user who is hit by this would categorize this 
> as a kernel regression in an existing driver?

No. If a user changes configuration and gets a hang, that's a bug but 
not a regression.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
