Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739Ab0AXWpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0AXWpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728Ab0AXWp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:45:27 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:63482 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab0AXWpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:45:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jpMuD1TH3lSz1dONgQkAKnTRl0bTtCgZq6vW1VCAfiSKOCk1N7w9caJY9vtNflaf3O
         1KFoSGF4wGTMl0lbDLSDxkCrQ7fuyA/0z8tsC7Mnck+KfW4NVXg4eXnDFYyq2rnXYpAf
         S3jwareX2tA0Oiq9BPRv8YkQ8H/oYJdzTCFuc=
Date: Sun, 24 Jan 2010 23:45:16 +0100
From: Johan Hovold <jhovold@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>,
       James Simmons <jsimmons@infradead.org>,
       Johan Hovold <jhovold@gmail.com>
Subject: Re: [Bug #15038] drm/ksm: fbdev blanking regression
Message-ID: <20100124224516.GA20080@localhost>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
 <hE3x9c-4KZM.A.4_F.ZKMXLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hE3x9c-4KZM.A.4_F.ZKMXLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 11:04:36PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15038
> Subject		: drm/ksm: fbdev blanking regression
> Submitter	: Johan Hovold <jhovold@gmail.com>
> Date		: 2010-01-06 17:00 (19 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=731b5a15a3b1474a41c2ca29b4c32b0f21bc852e
> References	: http://marc.info/?l=linux-kernel&m=126279726418748&w=4
> Handled-By	: James Simmons <jsimmons@infradead.org>

Issue remains in rc5.

/Johan

